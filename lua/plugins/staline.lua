return {
  'tamton-aquib/staline.nvim',
  event = 'BufRead',
  -- dependencies = { 'nvim-tree/nvim-web-devicons' },,
  config = function()
    -- Lower line
    require('staline').setup()
    -- Tabs
    -- require('stabline').setup()
  end,
}
