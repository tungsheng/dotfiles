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

local function setup_optional(server, executable, opts)
  if vim.fn.executable(executable) == 1 then
    setup(server, opts)
  end
end

-- Optional LSPs: only setup when the server binary is on PATH (avoids spawn errors)
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
  { server = "terraformls", executable = "terraform-ls" },
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
  root_dir = lspconfig.util.root_pattern(".git", "package.json"),
})
