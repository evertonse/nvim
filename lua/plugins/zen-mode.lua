return {
  -- :ZenMode
  'folke/zen-mode.nvim',
  event = 'BufEnter',
  cmd = { 'ZenMode' },
  enabled = true,
  opts = {
    plugins = {
      tmux = { enabled = true },
      options = {
        enabled = true,
        ruler = false, -- disables the ruler text in the cmd line area
        showcmd = false, -- disables the command in the last line of the screen
        -- you may turn on/off statusline in zen mode by setting 'laststatus'
        -- statusline will be shown only if 'laststatus' == 3
        laststatus = 0, -- turn off the statusline in zen mode
      },
    },
    on_open = function(_)
      vim.cmd [[set laststatus=0 ]]
    end,
    on_close = function(_)
      vim.cmd [[set laststatus=3 ]]
    end,
  },
}
