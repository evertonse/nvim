return {
  'tiagovla/scope.nvim',
  config = function()
    require('scope').setup {}
  end,
  lazy = false,
  event = 'VeryLazy',
  enabled = true,
}
