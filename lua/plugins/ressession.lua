return {
  'stevearc/resession.nvim',
  lazy = false,
  dependencies = {
    {
      'evertonse/scope.nvim',
      branch = 'main',
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
      local filetype = vim.bo[bufnr].filetype
      if buftype == 'help' then
        return true
      end
      if filetype == 'qf' or buftype == 'qf' then
        return false
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
        --  For tab-scoped sessions, the on_save and on_load methods of extensions will be disabled by default. There is a special config argument always available that can override this:
        enable_in_tab = true,
      },
      -- NOTE: I don't wanna save quicklist
      -- quickfix = true,
    },
  },
  config = function(_, opts)
    local resession = require 'resession'
    resession.setup(opts)
    -- resession.setup {}
    -- Resession does NOTHING automagically, so we have to set up some keymaps
    local maps = {
      n = {
        ['<leader>rss'] = { resession.save, 'Ressesion Save' },
        ['<leader>rsl'] = { resession.load, 'Ressesion Load' },
        ['<leader>rsd'] = { resession.delete, 'Ressesion delete' },
      },
    }
    SetKeyMaps(maps)
    -- Define a function to close the quickfix window
    local function close_quickfix()
      local quickfix_open = false
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.fn.getwininfo(win)[1].quickfix == 1 then
          quickfix_open = true
          break
        end
      end
      if quickfix_open then
        vim.cmd 'cclose'
      end
    end
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 then
          -- Save these to a different directory, so our manual sessions don't get polluted
          resession.load(vim.fn.getcwd(), { dir = 'session', silence_errors = true })
          vim.schedule(function()
            vim.cmd [[TrailBlazerLoadSession .trail.tbsv]]
          end)
          -- resession.load 'last'
          vim.cmd [[stopinsert]]
        end
      end,
      nested = true,
    })
    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        close_quickfix()
        resession.save(vim.fn.getcwd(), { dir = 'session', notify = true })
        vim.schedule(function()
          vim.cmd [[TrailBlazerSaveSession .trail.tbsv]]
        end)
        -- resession.save 'last'
      end,
    })
  end,
}
