return {
  'folke/persistence.nvim',
  -- event = 'BufReadPre', -- this will only start session saving when an actual file was opened
  event = 'VimEnter',
  -- lazy = false,
  enabled = true,
  opts = {
    options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'skiprtp' }, -- sessionoptions used for saving
  },
  config = function(_, opts)
    local persistence = require 'persistence'
    persistence.setup(opts)
    -- restore the session for the current directory
    vim.keymap.set('n', '<F7>', persistence.load, {})

    -- restore the last session
    vim.keymap.set('n', '<F5>', function()
      persistence.load { last = true }
    end, {})

    -- stop Persistence => session won't be saved on exit
    vim.keymap.set('n', '<leader><F5>', persistence.stop, {})

    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('persistence-lol', { clear = true }),
      callback = function(event)
        vim.api.nvim_input '<Esc>'
        persistence.load()
        print 'persistence just loaded'
        -- ShowStringAndWait(TableDump2(event))
      end,
    })
  end,
}
