local map = function(mode, lhs, rhs, opts)
  if lhs == '' then
    return
  end
  opts = vim.tbl_deep_extend('force', { silent = true }, opts or {})

  if type(lhs) == 'table' then
    for _, single_lhs in ipairs(lhs) do
      vim.keymap.set(mode, single_lhs, rhs, opts)
    end
  else
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local fix_buffers_per_window = function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    local parser_name = vim.treesitter.language.get_lang(ft)

    -- Reload the buffer with :edit to trigger filetype detection again, along with Lsp
    pcall(vim.api.nvim_buf_call, bufnr, vim.cmd.edit)

    -- Enable treesitter, maybe
    if not require('functions').disable_treesitter_highlight_when(parser_name, bufnr) then
      pcall(vim.api.nvim_buf_call, bufnr, vim.treesitter.start)
    else
      -- Just in case it's on
      pcall(vim.api.nvim_buf_call, bufnr, vim.treesitter.stop)
    end
  end
end

local fix_all_buffers = function()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_option(bufnr, 'buflisted') then
      local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
      local parser_name = vim.treesitter.language.get_lang(ft)

      pcall(vim.api.nvim_buf_call, bufnr, vim.cmd.edit)

      if not require('functions').disable_treesitter_highlight_when(parser_name, bufnr) then
        pcall(vim.api.nvim_buf_call, bufnr, vim.treesitter.start)
      else
        pcall(vim.api.nvim_buf_call, bufnr, vim.treesitter.stop)
      end
    end
  end
end

return {
  'stevearc/resession.nvim',
  lazy = false,
  -- event = 'VimEnter',
  enabled = true,
  dependencies = {
    {
      'evertonse/scope.nvim',
      branch = 'main',
      lazy = true,
    },
  },
  opts = {
    options = {
      'binary',
      -- 'bufhidden',
      'buflisted',
      'cmdheight',
      'diff',
      'filetype',
      'modifiable',
      'previewwindow',
      'readonly',
      'scrollbind',
      -- 'winfixheight',
      -- 'winfixwidth',
    },
    -- Show more detail about the sessions when selecting one to load.
    -- Disable if it causes lag.
    load_detail = false,
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
        enable_in_tab = false,
      },
      -- NOTE: I don't wanna save quicklist
      -- quickfix = true,
    },
  },
  config = function(_, opts)
    local resession = require 'resession'
    resession.setup(opts)

    -- Resession does NOTHING automagically, so we have to set up some keymaps
    map('n', '<leader>rss', resession.save, { desc = 'Ressesion Save' })
    map('n', '<leader>rsl', resession.load, { desc = 'Ressesion Load' })
    map('n', '<leader>rsd', resession.delete, { desc = 'Ressesion delete' })
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

    local trail_path = './.trail.tbsv'
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function(args)
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 then
          -- Save these to a different directory, so our manual sessions don't get polluted
          resession.load(vim.fn.getcwd(), { dir = 'session', silence_errors = false })

          vim.schedule(function()
            local ok, trail = pcall(require, 'trailblazer')
            if not ok then
              return
            end

            ok = pcall(trail.load_trailblazer_state_from_file, trail_path)
            if not ok then
              local _ = false and vim.notify("Couldn't load trailblazer session from" .. trail_path .. '.', vim.log.levels.WARN)
            end
          end)
          vim.schedule(function()
            fix_all_buffers()
          end)

          -- Restore UI
          vim.opt.cmdheight = 1
          vim.cmd 'stopinsert'
        end
      end,
    })

    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        close_quickfix()
        resession.save(vim.fn.getcwd(), { dir = 'session', notify = true })
        local ok, trail = pcall(require, 'trailblazer')
        if not ok then
          return
        end
        ok = pcall(trail.save_trailblazer_state_to_file, trail_path)
        if not ok then
          vim.fn.confirm("Couldn't save trailblazer session to" .. trail_path .. '.')
        end
        -- resession.save 'last'
      end,
      nested = true,
    })
  end,
}
