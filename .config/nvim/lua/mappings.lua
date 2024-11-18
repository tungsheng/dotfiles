require "nvchad.mappings"
local lazy = {}

local map = vim.keymap.set
-- local nomap = vim.keymap.del

-- map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("i", "jk", "<ESC>")

-- Neogit
map({ "n" }, "<leader>gs", "<CMD>Neogit<CR>", { desc = "Neogit status" })
map(
  { "n" },
  "<leader>gw",
  "<CMD>lua require('telescope').extensions.git_worktree.git_worktree()<CR>",
  { desc = "Git worktree list" }
)
map(
  { "n" },
  "<leader>ga",
  "<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
  { desc = "Git worktree add" }
)

-- Terminal mappings
map({ "t" }, "<ESC>", "<C-\\><C-n>", { desc = "exit terminal mode" })


-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
