-- I don't think I'll ever need to use this, but theses configs in here are always like this XD
require('lazy').setup {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup {}
  end,
  -- Docs: https://nvimdev.github.io/lspsaga/implement/
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons', -- optional
  },
}
