return {
  'rmagatti/alternate-toggler', --NOTE: Maybe instead of alternater we want CYCLER
  lazy = false,
  event = 'BufReadPost',
  config = function()
    require('alternate-toggler').setup {
      alternates = {
        ['=='] = '!=',
        ['!='] = '==',
        ['and'] = 'or',
        ['or'] = 'and',

        ['else'] = 'elif',
        ['elif'] = 'if',
        ['if'] = 'else',
        ['true'] = 'false',
        ['false'] = 'true',
      },
    }

    vim.keymap.set(
      'n',
      '<C-x>', -- <space><space>
      require('alternate-toggler').toggleAlternate
    )
  end,
}
