require "nvchad.mappings"

local map = vim.keymap.set
local del = vim.keymap.del

-- Remove NvChad's window navigation (vim-tmux-navigator handles these)
del("n", "<C-h>")
del("n", "<C-j>")
del("n", "<C-k>")
del("n", "<C-l>")

-- Git
map("n", "<leader>gs", "<CMD>Neogit<CR>", { desc = "Git status" })
map("n", "<leader>gw", "<CMD>Telescope git_worktree<CR>", { desc = "Git worktree list" })
map("n", "<leader>ga", "<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", { desc = "Git worktree add" })

-- Terminal
map("t", "<ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
