local configs = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

-- Simple servers with default config
local servers = { "html", "cssls", "vtsls", "marksman", "dockerls", "bashls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Emmet
lspconfig.emmet_ls.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "html", "css", "scss", "less", "sass", "vue", "svelte" },
}

-- JSON with schema support
lspconfig.jsonls.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}

-- ESLint
lspconfig.eslint.setup {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern(".git", "package.json"),
}
