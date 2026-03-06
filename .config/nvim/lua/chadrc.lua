-- Keep this file aligned with NvChad's nvconfig.lua structure:
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- It documents the available top-level config keys.

---@type ChadrcConfig
local M = {}

local function read_mason_packages()
  local manifest = vim.fn.stdpath "config" .. "/mason-packages.txt"
  if vim.fn.filereadable(manifest) == 0 then
    return {}
  end

  local packages = {}
  for _, line in ipairs(vim.fn.readfile(manifest)) do
    line = vim.trim(line)
    if line ~= "" and not line:match "^#" then
      table.insert(packages, line)
    end
  end

  return packages
end

M.base46 = {
  theme = "catppuccin",

  -- hl_override = {
  --   Comment = { italic = true },
  --   ["@comment"] = { italic = true },
  -- },
}

M.mason = {
  pkgs = read_mason_packages(),
}

return M
