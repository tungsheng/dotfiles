vim.g.mapleader = ' '

local keymap = vim.keymap

-- General
keymap.set('n', '<leader><ESC>', '<CMD>nohl<CR>')
keymap.set('n', '<leader>n', '<CMD>bnext<CR>')
keymap.set('n', '<leader>p', '<CMD>bprev<CR>')
keymap.set('n', '<leader>q', '<CMD>q<CR>')
keymap.set('n', '<leader>Q', '<CMD>qall<CR>')
keymap.set('n', '<leader><leader>', '<CMD>w<CR>')
keymap.set('n', 'x', '"_x')
keymap.set('n', '<leader>+', '<C-a>')
keymap.set('n', '<leader>-', '<C-x>')

-- Split
keymap.set('n', '<leader>sv', '<C-w>v') -- split vertically
keymap.set('n', '<leader>sh', '<C-w>s') -- split horizontally
keymap.set('n', '<leader>se', '<C-w>=') -- make equal width
keymap.set('n', '<leader>sx', '<CMD>close<CR>') -- close current split

-- Tab
keymap.set('n', '<leader>to', '<CMD>tabnew<CR>') -- open new tab
keymap.set('n', '<leader>tx', '<CMD>tabclose<CR>') -- close current tab
keymap.set('n', '<leader>tn', '<CMD>tabn<CR>') -- go to the next tab
keymap.set('n', '<leader>tp', '<CMD>tabp<CR>') -- go to the previous tab

-- Plugin keymaps
-- vim-maximizer
keymap.set('n', '<leader>sm', '<CMD>MaximizerToggle<CR>')

-- nvim-tree
keymap.set('n', '<leader>e', '<CMD>NvimTreeToggle<CR>')

-- telescope
keymap.set('n', '<leader>ff', '<CMD>Telescope find_files<CR>')
keymap.set('n', '<leader>fs', '<CMD>Telescope live_grep<CR>')
keymap.set('n', '<leader>fc', '<CMD>Telescope grep_string<CR>')
keymap.set('n', '<leader>fb', '<CMD>Telescope buffers<CR>')
keymap.set('n', '<leader>fh', '<CMD>Telescope help_tags<CR>')
