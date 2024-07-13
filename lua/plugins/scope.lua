return {
  'evertonse/scope.nvim',
  branch = 'main',
  config = function()
    require('scope').setup {}
  end,
  lazy = false,
  -- event = 'VeryLazy',
  enabled = true,
}
