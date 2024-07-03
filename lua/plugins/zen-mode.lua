return {
  -- :ZenMode
  'folke/zen-mode.nvim',
  event = 'BufEnter',
  enabled = false,
  opts = {
    plugins = { tmux = { enabled = true } },
    on_open = function(_)
      vim.cmd [[set laststatus=0 ]]
    end,
    on_close = function(_)
      vim.cmd [[set laststatus=3 ]]
    end,
  },
}
