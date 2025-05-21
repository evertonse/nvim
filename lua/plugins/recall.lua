-- https://github.com/fnune/recall.nvim?tab=readme-ov-file#project-specific-global-marks
return {
  'fnune/recall.nvim',
  version = '*',

  keys = {
    { '<leader>mm', function() require('recall').toggle() end, mode = 'n' },
    { '<leader>mn', function() require('recall').goto_next() end, mode = 'n' },
    { '<leader>mp', function() require('recall').goto_prev() end, mode = 'n' },
    { '<leader>mc', function() require('recall').clear() end, mode = 'n' },
    { '<leader>ml', ':Telescope recall<CR>', mode = 'n' },
  },
}
