return {
  cmd = { 'ols' },
  root_dir = function(fname)
    return require('lspconfig').util.root_pattern('ols.json', '.git')(fname) or vim.fn.getcwd()
  end,
  autostart = true, -- This is the important new option
  filetypes = { 'odin' }, -- Adjust this based on your server
  autoformat = false,
}
