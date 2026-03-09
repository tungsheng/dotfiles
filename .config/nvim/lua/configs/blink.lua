local M = {}

local terraform_filetypes = {
  terraform = true,
  ["terraform-vars"] = true,
  hcl = true,
}

local function is_terraform_filetype(bufnr)
  return terraform_filetypes[vim.bo[bufnr].filetype] == true
end

local function get_line_prefix(ctx)
  return string.sub(ctx.line or "", 1, ctx.cursor[2])
end

local function get_line_suffix(ctx)
  return string.sub(ctx.line or "", ctx.cursor[2] + 1)
end

local function get_terraform_node(ctx)
  local ok, parser = pcall(vim.treesitter.get_parser, ctx.bufnr)
  if not ok or not parser then
    return
  end

  local positions = {
    { ctx.cursor[1] - 1, ctx.cursor[2] },
    { ctx.cursor[1] - 1, math.max(ctx.cursor[2] - 1, 0) },
  }

  for _, pos in ipairs(positions) do
    local ok_node, node = pcall(vim.treesitter.get_node, {
      bufnr = ctx.bufnr,
      pos = pos,
    })
    if ok_node and node then
      return node
    end
  end
end

local function is_inside_terraform_block_with_treesitter(ctx)
  local node = get_terraform_node(ctx)
  if not node then
    return nil
  end

  while node do
    if node:type() == "block" then
      return true
    end

    node = node:parent()
  end

  return false
end

local function is_inside_terraform_block_with_scan(ctx)
  local lines = vim.api.nvim_buf_get_lines(ctx.bufnr, 0, ctx.cursor[1], false)
  if #lines == 0 then
    return false
  end

  lines[#lines] = string.sub(lines[#lines], 1, ctx.cursor[2])

  local state = {
    block_comment = false,
    heredoc = nil,
    in_string = false,
    depth = 0,
  }

  for _, line in ipairs(lines) do
    if state.heredoc then
      if vim.trim(line) == state.heredoc then
        state.heredoc = nil
      end
    else
      local i = 1
      while i <= #line do
        local ch = line:sub(i, i)
        local pair = line:sub(i, i + 1)

        if state.block_comment then
          local comment_end = line:find("*/", i, true)
          if not comment_end then
            break
          end

          state.block_comment = false
          i = comment_end + 2
        elseif state.in_string then
          if ch == "\\" then
            i = i + 2
          elseif ch == '"' then
            state.in_string = false
            i = i + 1
          else
            i = i + 1
          end
        elseif pair == "/*" then
          state.block_comment = true
          i = i + 2
        elseif pair == "//" or ch == "#" then
          break
        elseif ch == '"' then
          state.in_string = true
          i = i + 1
        elseif ch == "{" then
          state.depth = state.depth + 1
          i = i + 1
        elseif ch == "}" then
          state.depth = math.max(0, state.depth - 1)
          i = i + 1
        else
          i = i + 1
        end
      end

      local heredoc = line:match("<<%-?([%a_][%w_]*)")
      if heredoc then
        state.heredoc = heredoc
      end
    end
  end

  return state.depth > 0
end

local function is_terraform_inside_block(ctx)
  if not is_terraform_filetype(ctx.bufnr) then
    return false
  end

  local treesitter_result = is_inside_terraform_block_with_treesitter(ctx)
  if treesitter_result ~= nil then
    return treesitter_result
  end

  return is_inside_terraform_block_with_scan(ctx)
end

local function is_terraform_member_trigger(ctx)
  if not is_terraform_filetype(ctx.bufnr) then
    return false
  end

  local trigger = ctx.trigger or {}
  local is_member_trigger = trigger.initial_kind == "trigger_character" and trigger.initial_character == "."
  if is_member_trigger then
    return true
  end

  return get_line_prefix(ctx):match("[%w_]+%.$") ~= nil
end

local get_terraform_completion_context

local function get_terraform_var_member_context(ctx)
  if get_terraform_completion_context(ctx) ~= "member" then
    return
  end

  local prefix = get_line_prefix(ctx)
  local current_member = prefix:match("var%.([%w_]*)$")
  if current_member == nil then
    return
  end

  local suffix = get_line_suffix(ctx):match("^[%w_]*") or ""
  return {
    current_member = current_member,
    start_col = ctx.cursor[2] - #current_member,
    end_col = ctx.cursor[2] + #suffix,
  }
end

local function get_terraform_module_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return vim.uv.cwd() or vim.fn.getcwd()
  end

  return vim.fs.dirname(name)
end

local function get_module_buffer_by_path(path)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_name(bufnr) == path then
      return bufnr
    end
  end
end

local function get_module_file_lines(path)
  local bufnr = get_module_buffer_by_path(path)
  if bufnr then
    return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  end

  if vim.fn.filereadable(path) == 1 then
    return vim.fn.readfile(path)
  end

  return {}
end

local function get_terraform_module_variables(ctx)
  local module_dir = get_terraform_module_dir(ctx.bufnr)
  local variables = {}

  local function add_variable(name)
    if name and name ~= "" then
      variables[name] = true
    end
  end

  for name, kind in vim.fs.dir(module_dir) do
    if kind == "file" and name:match("%.tf$") then
      local path = vim.fs.joinpath(module_dir, name)
      for _, line in ipairs(get_module_file_lines(path)) do
        add_variable(line:match('^%s*variable%s+"([^"]+)"%s*{'))
      end
    end
  end

  local names = vim.tbl_keys(variables)
  table.sort(names)
  return names
end

local function get_terraform_lsp_metadata(ctx, items)
  for _, item in ipairs(items) do
    if item.source_id == "lsp" then
      return {
        source_id = item.source_id,
        source_name = item.source_name,
        cursor_column = item.cursor_column or ctx.cursor[2],
        client_id = item.client_id,
        client_name = item.client_name,
      }
    end
  end

  local terraformls
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = ctx.bufnr })) do
    if client.name == "terraformls" then
      terraformls = client
      break
    end
  end

  return {
    source_id = "lsp",
    source_name = "LSP",
    cursor_column = ctx.cursor[2],
    client_id = terraformls and terraformls.id or nil,
    client_name = terraformls and terraformls.name or nil,
  }
end

local function build_terraform_var_item(ctx, member_ctx, variable_name, metadata)
  return {
    label = "var." .. variable_name,
    filterText = variable_name,
    kind = vim.lsp.protocol.CompletionItemKind.Variable,
    sortText = variable_name,
    source_id = metadata.source_id,
    source_name = metadata.source_name,
    cursor_column = metadata.cursor_column,
    client_id = metadata.client_id,
    client_name = metadata.client_name,
    documentation = {
      kind = "markdown",
      value = "Terraform module variable",
    },
    textEdit = {
      newText = variable_name,
      range = {
        start = { line = ctx.cursor[1] - 1, character = member_ctx.start_col },
        ["end"] = { line = ctx.cursor[1] - 1, character = member_ctx.end_col },
      },
    },
  }
end

local function extend_terraform_var_items(ctx, items)
  local member_ctx = get_terraform_var_member_context(ctx)
  if not member_ctx then
    return items
  end

  local metadata = get_terraform_lsp_metadata(ctx, items)
  local seen = {}
  for _, item in ipairs(items) do
    seen[item.label] = true
  end

  for _, variable_name in ipairs(get_terraform_module_variables(ctx)) do
    local label = "var." .. variable_name
    if not seen[label] then
      table.insert(items, build_terraform_var_item(ctx, member_ctx, variable_name, metadata))
    end
  end

  return items
end

get_terraform_completion_context = function(ctx)
  if ctx._terraform_completion_context then
    return ctx._terraform_completion_context
  end

  if not is_terraform_filetype(ctx.bufnr) then
    ctx._terraform_completion_context = "other"
    return ctx._terraform_completion_context
  end

  if is_terraform_member_trigger(ctx) then
    ctx._terraform_completion_context = "member"
    return ctx._terraform_completion_context
  end

  if is_terraform_inside_block(ctx) then
    ctx._terraform_completion_context = "block"
    return ctx._terraform_completion_context
  end

  ctx._terraform_completion_context = "root"
  return ctx._terraform_completion_context
end

function M.apply(opts)
  opts.sources = opts.sources or {}
  opts.sources.providers = opts.sources.providers or {}
  opts.sources.providers.lsp = opts.sources.providers.lsp or {}
  opts.sources.providers.snippets = opts.sources.providers.snippets or {}
  opts.completion = opts.completion or {}
  opts.completion.list = opts.completion.list or {}
  opts.completion.list.selection = opts.completion.list.selection or {}

  local lsp = opts.sources.providers.lsp
  local snippets = opts.sources.providers.snippets
  local previous_lsp_transform_items = lsp.transform_items
  local previous_should_show_items = snippets.should_show_items
  local previous_preselect = opts.completion.list.selection.preselect
  local previous_auto_insert = opts.completion.list.selection.auto_insert

  lsp.transform_items = function(ctx, items)
    if type(previous_lsp_transform_items) == "function" then
      items = previous_lsp_transform_items(ctx, items)
    end

    return extend_terraform_var_items(ctx, items)
  end

  snippets.should_show_items = function(ctx, items)
    local terraform_context = get_terraform_completion_context(ctx)
    if terraform_context == "member" or terraform_context == "block" then
      return false
    end

    if type(previous_should_show_items) == "function" then
      return previous_should_show_items(ctx, items)
    end

    if previous_should_show_items == nil then
      return true
    end

    return previous_should_show_items
  end

  opts.completion.list.selection.preselect = function(ctx)
    local terraform_context = get_terraform_completion_context(ctx)
    if terraform_context == "member" or terraform_context == "block" then
      return false
    end

    if type(previous_preselect) == "function" then
      return previous_preselect(ctx)
    end

    if previous_preselect == nil then
      return true
    end

    return previous_preselect
  end

  opts.completion.list.selection.auto_insert = function(ctx)
    local terraform_context = get_terraform_completion_context(ctx)
    if terraform_context == "member" or terraform_context == "block" then
      return false
    end

    if type(previous_auto_insert) == "function" then
      return previous_auto_insert(ctx)
    end

    if previous_auto_insert == nil then
      return true
    end

    return previous_auto_insert
  end

  return opts
end

return M
