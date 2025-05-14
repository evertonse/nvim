return {
  'mbbill/undotree',
  enabled = false,
  lazy = true,
  event = 'BufEnter',
  keys = {
    { '<leader>ut', '<cmd>UndotreeToggle<CR>', desc = 'Toggle undotree' },
  },
}
