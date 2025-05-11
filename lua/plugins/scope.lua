return {
  'evertonse/scope.nvim',
  branch = 'main',
  config = function()
    require('scope').setup {}
  end,
  lazy = true,
  keys = { '<leader>x' },
  -- event = 'VeryLazy',
  enabled = true,
}
