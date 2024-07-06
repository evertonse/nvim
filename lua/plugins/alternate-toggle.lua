return {
  'rmagatti/alternate-toggler', --NOTE: Maybe instead of alternater we want CYCLER
  lazy = false,
  event = 'BufReadPost',
  config = function()
    require('alternate-toggler').setup {
      alternates = {
        ['=='] = '!=',
        ['else'] = 'elif',
        ['true'] = 'false',
      },
    }

    vim.keymap.set(
      'n',
      '<C-x>', -- <space><space>
      require('alternate-toggler').toggleAlternate
    )
  end,
}
