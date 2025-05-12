return {
  'evertonse/scope.nvim',
  branch = 'main',
  event = 'VeryLazy',
  -- lazy = true,
  keys = { { '<leader>x', modes = { 'n' } } },
  enabled = true,
  dependencies = {
    {
      'moll/vim-bbye',
      -- enabled = true,
      -- lazy = false,
    },
  },
  config = function()
    require('scope').setup {}
  end,
}
