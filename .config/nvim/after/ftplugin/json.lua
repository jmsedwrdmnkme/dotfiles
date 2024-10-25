if vim.fn.executable('vscode-json-language-server') == 1 then
  vim.lsp.start({
    name = 'VSCode JSON Language Server',
    cmd = { 'vscode-json-language-server', '--stdio' },
    root_dir = vim.fs.dirname(vim.fs.find({'package.json', '.git'}, { upward = true })[1])
  })
end
