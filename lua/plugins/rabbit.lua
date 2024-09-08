return {
  'voxelprismatic/rabbit.nvim',
  lazy = false,
  config = function(opts)
    require('rabbit').setup { { opts } } -- Detailed below
  end,
}
