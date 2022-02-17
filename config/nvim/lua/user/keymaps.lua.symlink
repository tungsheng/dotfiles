local map = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    {noremap = true, silent = true}
  )
end


-- map the leader key
map('', '<Space>', '')
vim.g.mapleader = ' '  -- 'vim.g' sets global variables

map('n', '<leader><esc>', '<CMD>nohlsearch<CR>')
map('n', '<leader>n', '<CMD>bnext<CR>')
map('n', '<leader>p', '<CMD>bprev<CR>')
map('n', '<leader>q', '<CMD>q<CR>')
map('n', '<leader>Q', '<CMD>wqa<CR>')
map('n', '<leader><leader>', '<CMD>w<CR>')

-- tab mapping
map('n', 'tj', '<CMD>tabfirst<CR>')
map('n', 'tl', '<CMD>tabnext<CR>')
map('n', 'th', '<CMD>tabprev<CR>')
map('n', 'tk', '<CMD>tablast<CR>')
map('n', 'tn', '<CMD>tabnew<CR>')
map('n', 'td', '<CMD>tabclose<CR>')

-- nvim-tree
map('n', '<leader>h', '<CMD>NvimTreeToggle<CR>')

-- toggle invisible characters
map('n', '<leader>l', '<CMD>set list!<CR>')

-- switch between current and last buffer
map('n', '<leader>.', '<C-^>')

-- navigate
map('n', "<C-h>", "<CMD>lua require('Navigator').left()<CR>")
map('n', "<C-k>", "<CMD>lua require('Navigator').up()<CR>")
map('n', "<C-l>", "<CMD>lua require('Navigator').right()<CR>")
map('n', "<C-j>", "<CMD>lua require('Navigator').down()<CR>")
map('n', "<C-p>", "<CMD>lua require('Navigator').previous()<CR>")

-- terminal
map('n', '<leader>`', '<CMD>split term://zsh<CR>')

-- reload init.lua
map('n', '<Leader>r', '<CMD>source $MYVIMRC<CR>')

-- telescope
map('n', '<leader>ff', "<CMD>lua require('telescope.builtin').find_files()<CR>")
map('n', '<leader>fs', "<CMD>lua require('telescope.builtin').grep_string()<CR>")
map('n', '<leader>fg', "<CMD>lua require('telescope.builtin').live_grep()<CR>")
map('n', '<leader>fb', "<CMD>lua require('telescope.builtin').buffers()<CR>")
map('n', '<leader>fh', "<CMD>lua require('telescope.builtin').help_tags()<CR>")

-- lsp
map('n', 'gd', '<CMD>lua vim.lsp.buf.definition()<CR>')
map('n', 'gD', '<CMD>lua vim.lsp.buf.declaration()<CR>')
map('n', 'gr', '<CMD>lua vim.lsp.buf.references()<CR>')
map('n', 'gi', '<CMD>lua vim.lsp.buf.implementation()<CR>')
map('n', 'K', '<CMD>lua vim.lsp.buf.hover()<CR>')
