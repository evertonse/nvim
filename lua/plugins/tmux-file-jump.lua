return {
  'canova/tmux-file-jump.nvim',
  event = 'VeryLazy',
  lazy = false,
  dependencies = {
    'nvim-telescope/telescope.nvim',
    -- 'ibhagwan/fzf-lua', -- Or fzf-lua if you prefer.
  },
  config = function()
    local tmux_file_jump = require 'tmux-file-jump'
    tmux_file_jump.setup {
      -- viewer = "fzf-lua" -- Uncomment for fzf-lua.
    }

    -- Change your keymaps as you like.
    vim.keymap.set('n', '<leader>tl', tmux_file_jump.list_files, { desc = 'List all file paths in the other tmux panes' })
    vim.keymap.set(
      'n',
      '<leader>tj',
      tmux_file_jump.jump_first,
      { desc = 'Go to the first (from bottom) file path in the other tmux panes' }
    )
  end,
}
