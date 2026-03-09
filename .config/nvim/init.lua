vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
local lazy_commit = "306a05526ada86a7b30af95c5cc81ffba93fef97"

local function run_bootstrap(cmd)
  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    error(output)
  end
end

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  run_bootstrap { "git", "clone", "--filter=blob:none", "--no-checkout", repo, lazypath }
  run_bootstrap { "git", "-C", lazypath, "checkout", lazy_commit }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

require "configs.filetypes"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
