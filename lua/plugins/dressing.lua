return {
  'stevearc/dressing.nvim',
  event = 'VeryLazy',
  opts = {
    input = {

      mappings = {
        n = {
          ['<Esc>'] = 'Close',
          ['<CR>'] = 'Confirm',
        },
        i = {
          ['<esc>'] = 'Close',
          ['<CR>'] = 'Confirm',
          ['<Up>'] = 'HistoryPrev',
          ['<Down>'] = 'HistoryNext',
        },
      },
    },
  },
  config = function(_, opts)
    require('dressing').setup(opts)
  end,
}
