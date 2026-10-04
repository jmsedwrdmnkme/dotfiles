vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false }) -- Leader key fix
vim.g.mapleader = " " -- Leader key set to space

vim.keymap.set('n', '<Tab>', ':Lexplore<CR>') -- Opens Netrw with tab
