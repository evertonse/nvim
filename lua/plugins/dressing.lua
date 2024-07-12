return {
  'stevearc/dressing.nvim',
  event = 'VeryLazy',
  opts = {
    input = {

      default_prompt = 'Input',
      -- These are passed to nvim_open_win
      border = 'single',
      -- 'editor' and 'win' will default to being centered
      relative = 'win',
      -- Can be 'left', 'right', or 'center'
      title_pos = 'left',
      mappings = {
        n = {
          ['<Esc>'] = 'Close',
          ['<CR>'] = 'Confirm',
        },
        i = {
          ['<esc>'] = 'Close',
          ['<C-c>'] = '<c-c>',
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
