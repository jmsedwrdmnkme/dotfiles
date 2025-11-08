if vim.fn.executable('devsense-php-ls') == 1 then
  vim.lsp.start({
    name = 'DEVSENSE PHP Language Server',
    cmd = { 'devsense-php-ls', '--stdio' },
    root_dir = vim.fs.dirname(vim.fs.find({'package.json', '.git'}, { upward = true })[1])
  })
end
