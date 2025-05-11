return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = { 'FzfLua' },
  lazy = true,
  config = function()
    -- calling `setup` is optional for customization
    require('fzf-lua').setup {}
  end,
}
