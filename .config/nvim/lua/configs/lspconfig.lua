local configs = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"

-- Common options for all servers
local defaults = {
  on_init = configs.on_init,
  on_attach = configs.on_attach,
  capabilities = configs.capabilities,
}

-- Helper to merge defaults with custom options
local function setup(server, opts)
  lspconfig[server].setup(vim.tbl_extend("force", defaults, opts or {}))
end

-- Optional LSPs: only setup when the server binary is on PATH (avoids spawn errors)
local optional_servers = {
  bashls = "bash-language-server",
  ruff = "ruff",
}
for server, executable in pairs(optional_servers) do
  if vim.fn.executable(executable) == 1 then
    setup(server)
  end
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
  root_dir = lspconfig.util.root_pattern(".git", "package.json"),
})
