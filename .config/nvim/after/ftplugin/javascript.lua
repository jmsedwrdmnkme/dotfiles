if vim.fn.executable('typescript-language-server') == 1 then
  vim.lsp.start({
    name = 'TypeScript Language Server',
    cmd = { 'typescript-language-server', '--stdio' },
    root_dir = vim.fs.dirname(vim.fs.find({'package.json', '.git'}, { upward = true })[1])
  })
end
