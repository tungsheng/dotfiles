local M = {}

function M.apply(opts)
  opts.sources = opts.sources or {}
  opts.sources.providers = opts.sources.providers or {}
  opts.sources.providers.snippets = opts.sources.providers.snippets or {}

  local snippet_opts = opts.sources.providers.snippets.opts or {}
  local extended_filetypes = snippet_opts.extended_filetypes or {}

  opts.sources.providers.snippets.opts = vim.tbl_deep_extend("force", snippet_opts, {
    extended_filetypes = vim.tbl_deep_extend("force", extended_filetypes, {
      tf = { "terraform" },
      hcl = { "terraform" },
    }),
  })

  return opts
end

return M
