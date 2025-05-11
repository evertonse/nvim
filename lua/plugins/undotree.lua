return {
  'mbbill/undotree',
  enabled = true,
  lazy = true,
  event = 'BufEnter',
  keys = {
    { '<leader>ut', '<cmd>UndotreeToggle<CR>', desc = 'Toggle undotree' },
  },
}
