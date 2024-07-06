return {
  'stevearc/resession.nvim',
  lazy = false,
  dependencies = {
    {
      'tiagovla/scope.nvim',
      lazy = false,
    },
  },
  opts = {
    options = {
      'binary',
      -- 'bufhidden',
      'buflisted',
      -- 'cmdheight',
      'diff',
      'filetype',
      'modifiable',
      'previewwindow',
      'readonly',
      'scrollbind',
      'winfixheight',
      'winfixwidth',
    },
    -- Show more detail about the sessions when selecting one to load.
    -- Disable if it causes lag.
    load_detail = true,
    -- List order ["modification_time", "creation_time", "filename"]
    load_order = 'modification_time',
    -- override default filter
    buf_filter = function(bufnr)
      local buftype = vim.bo[bufnr].buftype
      if buftype == 'help' then
        return true
      end
      if buftype ~= '' and buftype ~= 'acwrite' then
        return false
      end
      if vim.api.nvim_buf_get_name(bufnr) == '' then
        return false
      end

      -- this is required, since the default filter skips nobuflisted buffers
      return true
    end,
    extensions = {
      scope = {
        -- For tab-scoped sessions, the on_save and on_load methods of extensions will be disabled by default. There is a special config argument always available that can override this:
        -- enable_in_tab = true,
      },
    }, -- add scope.nvim extension
  },
  config = function(_, opts)
    local resession = require 'resession'
    -- resession.setup(opts)
    resession.setup {}
    -- Resession does NOTHING automagically, so we have to set up some keymaps
    vim.keymap.set('n', '<leader>rss', resession.save)
    vim.keymap.set('n', '<leader>rsl', resession.load)
    vim.keymap.set('n', '<leader>rsd', resession.delete)
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 then
          -- Save these to a different directory, so our manual sessions don't get polluted
          -- resession.load(vim.fn.getcwd(), { dir = 'dirsession', silence_errors = true })
          resession.load 'last'
          vim.cmd [[stopinsert]]
        end
      end,
      nested = true,
    })
    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        resession.save 'last'
        -- resession.save(vim.fn.getcwd(), { dir = 'dirsession', notify = false })
      end,
    })
  end,
}
