local configs = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"
local util = lspconfig.util

local capabilities = vim.deepcopy(configs.capabilities)
local has_blink, blink = pcall(require, "blink.cmp")
if has_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

-- Common options for all servers
local defaults = {
  on_init = configs.on_init,
  on_attach = configs.on_attach,
  capabilities = capabilities,
}

-- Helper to merge defaults with custom options
local function setup(server, opts)
  lspconfig[server].setup(vim.tbl_extend("force", defaults, opts or {}))
end

local function resolve_executable(executable)
  local system_path = vim.fn.exepath(executable)
  if system_path ~= "" then
    return system_path
  end

  local mason_path = vim.fs.joinpath(vim.fn.stdpath "data", "mason", "bin", executable)
  if vim.fn.executable(mason_path) == 1 then
    return mason_path
  end
end

local function setup_optional(server, executable, opts)
  local resolved = resolve_executable(executable)
  if not resolved then return end

  local merged_opts = vim.deepcopy(opts or {})
  local default_cmd = vim.deepcopy(lspconfig[server].document_config.default_config.cmd or { executable })
  local cmd = vim.deepcopy(merged_opts.cmd or default_cmd)

  if #cmd == 0 then
    cmd = { resolved }
  else
    cmd[1] = resolved
  end

  merged_opts.cmd = cmd
  setup(server, merged_opts)
end

local function terraform_root_dir(fname)
  return util.root_pattern(".terraform", ".terraform.lock.hcl", ".git")(fname) or util.path.dirname(fname)
end

-- Optional LSPs: only setup when the server binary is available via PATH or Mason.
local optional_servers = {
  { server = "bashls", executable = "bash-language-server" },
  { server = "ruff", executable = "ruff" },
  {
    server = "yamlls",
    executable = "yaml-language-server",
    opts = {
      settings = {
        yaml = {
          schemaStore = {
            enable = false,
            url = "",
          },
          schemas = require("schemastore").yaml.schemas(),
        },
      },
    },
  },
  {
    server = "terraformls",
    executable = "terraform-ls",
    opts = {
      root_dir = terraform_root_dir,
      single_file_support = true,
    },
  },
  { server = "helm_ls", executable = "helm_ls" },
}
for _, config in ipairs(optional_servers) do
  setup_optional(config.server, config.executable, config.opts)
end

-- Simple servers with default config (expected to be installed)
local simple_servers = { "html", "cssls", "vtsls", "marksman", "dockerls" }
for _, lsp in ipairs(simple_servers) do
  setup(lsp)
end

-- Emmet (extended filetypes)
setup("emmet_ls", {
  filetypes = { "html", "css", "scss", "less", "sass", "vue", "svelte" },
})

-- JSON with schema support
setup("jsonls", {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

-- ESLint
setup("eslint", {
  root_dir = util.root_pattern(".git", "package.json"),
})
