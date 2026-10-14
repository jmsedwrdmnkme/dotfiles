-- Remove Global Default Key mapping
vim.keymap.del("n", "grn") -- Rename symbol
vim.keymap.del("n", "gra") -- Code action
vim.keymap.del("n", "grr") -- List references
vim.keymap.del("n", "gri") -- Go to implementation
vim.keymap.del("n", "gO")  -- Document symbols outline

-- Create keymapping
-- LspAttach: After an LSP Client performs "initialize" and attaches to a buffer.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function (args)
    local keymap = vim.keymap
    local lsp = vim.lsp
    local bufopts = { noremap = true, silent = true }

    -- List all references to the symbol under the cursor
    keymap.set("n", "gr", lsp.buf.references, bufopts)
    -- Jump to the definition of the symbol under the cursor
    keymap.set("n", "gd", lsp.buf.definition, bufopts)
    -- Rename the symbol under the cursor across the project
    keymap.set("n", "<space>rn", lsp.buf.rename, bufopts)
    -- Show hover documentation for the symbol under the cursor
    keymap.set("n", "K", lsp.buf.hover, bufopts)
    -- Format the current buffer without blocking the editor
    keymap.set("n", "<space>f", function()
      vim.lsp.buf.format({ async = true })
    end, bufopts)
  end
})

-- Start these language servers (configs from lsp/<name>.lua or nvim-lspconfig)
vim.lsp.enable({ "intelephense", "stylelint_lsp", "css_variables", "css_lsp", "typescript_lsp" })
