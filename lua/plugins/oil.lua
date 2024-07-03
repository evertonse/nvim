return {
  'stevearc/oil.nvim',
  event = 'VimEnter',
  enabled = true,
  opts = {},
  config = function()
    require 'custom.plugins.configs.oil'
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    vim.keymap.set('n', '<leader>o', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
  end,
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
