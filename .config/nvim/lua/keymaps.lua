vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })       -- Leader key fix
vim.g.mapleader = " "                                                           -- Leader key set to space

vim.keymap.set('n', '<Tab>', ':Lexplore<CR>')                                   -- Opens Netrw with tab

vim.keymap.set({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true }) -- n always searches forward
vim.keymap.set({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true }) -- N always searches backward
