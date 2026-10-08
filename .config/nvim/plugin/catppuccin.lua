vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" }
})

require("catppuccin").setup({
  -- Set vim.g.terminal_color_0..15 so :terminal / snacks terminal buffers
  -- use the catppuccin palette for ANSI colors
  term_colors = true,
})

vim.cmd.colorscheme "catppuccin-nvim"
