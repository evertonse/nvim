return {
  'rmagatti/alternate-toggler', --NOTE: Maybe instead of alternater we want CYCLER
  config = function()
    require('alternate-toggler').setup {
      alternates = {
        ['=='] = '!=',
        ['else'] = 'elif',
      },
    }

    vim.keymap.set(
      'n',
      '<C-x>', -- <space><space>
      require('alternate-toggler').toggleAlternate
    )
  end,
  event = 'BufReadPost',
}
