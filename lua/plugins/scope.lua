return {
  'evertonse/scope.nvim',
  branch = 'main',
  event = 'VeryLazy',
  lazy = true,
  keys = { { '<leader>x', modes = { 'n' } } },
  enabled = true,
  dependencies = {
    {
      'moll/vim-bbye',
    },
  },
  config = function()
    require('scope').setup {}
  end,
}
