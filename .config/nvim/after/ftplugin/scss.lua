if vim.fn.executable('vscode-css-language-server') == 1 then
  vim.lsp.start({
    name = 'VSCode CSS Language Server',
    cmd = { 'vscode-css-language-server', '--stdio' },
    root_dir = vim.fs.dirname(vim.fs.find({'package.json', '.git'}, { upward = true })[1]),
    settings = {
      scss = {
        validate = true
      }
    }
  })
end
