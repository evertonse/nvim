return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- this will only start session saving when an actual file was opened
  lazy = false,
  enabled = false,
  opts = {
    options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
  },
  config = function(_, opts)
    require('persistence').setup(opts)
    -- restore the session for the current directory
    vim.keymap.set('n', '<leader><F7>', require('persistence').load, {})

    -- restore the last session
    vim.keymap.set('n', '<leader><F5>', function()
      require('persistence').load { last = true }
    end, {})

    -- stop Persistence => session won't be saved on exit
    vim.keymap.set('n', '<leader><F6>', require('persistence').stop, {})

    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('persistence', { clear = true }),
      callback = function(event)
        require('persistence').load { last = true }
        -- ShowStringAndWait(TableDump2(event))
      end,
    })
  end,
}
