vim.pack.add({
  -- snacks.nvim provides the terminal used by claudecode.nvim
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/coder/claudecode.nvim" },
})

-- vim.pack loads plugins eagerly, so the `:ClaudeCode*` commands are defined
-- here at startup; no command stubs are needed as they were with lazy.nvim.
require("claudecode").setup()

local map = vim.keymap.set

map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
map("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
map("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
map("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })
-- Diff management
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

-- File explorer buffers: add the file under the cursor
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("claudecode_tree_add", { clear = true }),
  pattern = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
  callback = function(args)
    map("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", { buffer = args.buf, desc = "Add file" })
  end,
})
