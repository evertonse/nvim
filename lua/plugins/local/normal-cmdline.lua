--- Short names
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

local getpos = function()
  return vim.api.nvim_win_get_cursor(0)
end

local setpos = function(pos)
  vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] })
end

local au = vim.api.nvim_create_autocmd
local feedkeys = function(keys, behaviour)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), behaviour or 'n', false)
end

local input = vim.api.nvim_input
local schedule = vim.schedule

--- Helpers
local inspect = function(arg)
  vim.print(vim.inspect(arg))
  -- exit(0)
end

local is_in_cmdline = function()
  return vim.fn.getcmdwintype() ~= '' or vim.fn.mode():match '^[/:]' ~= nil
end

--- Last cmd typed but not executed
local last_cmd = ''
--- Not used for now, because this affects usage of ':' from vim.cmd. It's not good when this is triggered from lua code instead of keymaps.
--- And it doesn't seem a way to make this distinction, bummer :/
local should_restore_last_cmd = false

--- Data from previous event
local previous = {
  opt = {
    laststatus = nil,
    cmdheight = nil,
    more = nil,
  },

  wo = {
    number = nil,
    relativenumber = nil,
  },

  g = {
    ministatusline_disable = nil,
  },

  restored = false,
  position = nil,
}

local save_opts = function()
  --- Save everything we're about to change to ensure nice text alignment
  --- when going from and into normal and insert mode.
  previous.opt.laststatus = vim.opt.laststatus:get()
  previous.opt.cmdheight = vim.opt.cmdheight:get()
  previous.opt.cmdwinheight = vim.opt.cmdwinheight:get()
  previous.opt.more = vim.opt.more:get()
  previous.g.ministatusline_disable = vim.g.ministatusline_disable

  previous.restored = false
  previous.position = vim.fn.getcmdpos()

  --- NOTE: If lastatus is not 0, the statusline will be in the way of the text
  --- At the same time if we set to anything else will get statusline
  --- on every other window, even if the user didn't want that. Ideally, only 1 status line would be on without being in the way
  --- The other solution is momentarily disable the lualine of ministatusline and other plugins
  vim.opt.laststatus = 0
  vim.opt.cmdheight = 0
  vim.opt.cmdwinheight = 3
  vim.opt.more = false
  vim.g.ministatusline_disable = true
  should_restore_last_cmd = false
end

local restore_opts = function()
  vim.opt.laststatus = previous.opt.laststatus
  vim.opt.cmdheight = previous.opt.cmdheight
  vim.opt.cmdwinheight = previous.opt.cmdwinheight
  vim.opt.more = previous.opt.more
  vim.g.ministatusline_disable = previous.g.ministatusline_disable

  previous.restored = true
  should_restore_last_cmd = false
end

local set_local_opts = function()
  vim.wo.number = false
  vim.wo.relativenumber = false
  --- TODO: Check that is doesn't mess with other signcolumns
  vim.opt_local.signcolumn = 'no'
end

local setup_autocommands = function()
  --- Restore cmdline if we interrupted previously
  au('CmdlineEnter', {
    pattern = '*',
    callback = function(event)
      local line = vim.fn.getcmdline()
      if should_restore_last_cmd and (line and line:len() == 0 and vim.fn.getcmdtype() == ':') then
        vim.fn.setcmdline(last_cmd)
      end
    end,
  })

  --- Where all the magic happens triggered by simply going into cmdwin
  au('CmdwinEnter', {
    pattern = '*',
    callback = function(event)
      --- NOTE: Throughout the 'simulation' of inputs we use 'nvim_input' which is low level, seemed smoother then 'feedkeys'.

      --- Match vim regular buffer behaviour when quitting from insert mode into normal mode
      local col = previous.position - 2
      setpos { getpos()[1], math.max(col, 0) }

      -- Changing settings (i.e. saving opts) should have happened before entering cmdwin
      assert(previous.restored == false)

      --- Since we're setting locally, if vim is nice to was, it'll restore whenever we quit this window, but you never know (unless testing and reading too much docs) since this cmdline window is special.
      set_local_opts()

      --- Close the completion window if we're using cmp.
      --- Idk how to close regardless of which completion plugins (or wild).
      local ok, cmp = pcall(require, 'cmp')
      if ok and cmp.close then
        schedule(cmp.close)
      end

      au({ 'CmdwinLeave', 'WinEnter' }, {
        once = true,
        callback = function(event)
          if previous.restored then
            return
          end
          restore_opts()
        end,
      })

      au('ModeChanged', {
        pattern = '*:[i]*', -- Insert mode
        once = true,
        callback = function()
          local pos = getpos()
          setpos { pos[1], 0 }
          feedkeys '<c-c>'
          for i = 1, pos[2] do
            input '<Right>'
          end

          schedule(function()
            --- NOTE: 'redrawstatus' isn't enough when cmdwinheight > 1
            vim.cmd [[redraw]]
          end)
        end,
      })

      local opts = { buffer = event.buf, noremap = true, silent = true }

      map({ 'n' }, '<C-c>', '<Nop>', opts)

      -- TODO: Saving last_cmd in normal mode should be *behind a flag*
      local save_in_normal_mode = false
      map({ 'n' }, '<Esc>', function()
        if save_in_normal_mode then
          last_cmd = vim.fn.getline '.'
        end
        vim.cmd [[stopinsert]]
        vim.cmd [[q!]]
      end, opts)

      map({ 'x', 'v', 'n' }, '<CR>', function()
        feedkeys '<CR>'
        schedule(function()
          last_cmd = ''
        end)
      end, opts)
    end,
  })
end

local M = {}

M.goto_cmdline_window_from_cmdline = function()
  save_opts()
  input '<c-f>'
end

M.setup = function()
  local _ = false -- Not necessary for. But if any problems occurs I'll leave the code for easy options setting
    and schedule(function()
      vim.opt.cmdwinheight = 2
      vim.opt.cmdheight = 1
      vim.opt.more = false
      vim.opt.showcmd = false
      vim.opt.showmode = false
      vim.opt.showcmdloc = 'last'
    end)

  local opts_global = { noremap = true, silent = true }

  --- Override they keys we need to make it work
  map({ 'n' }, 'q:', function()
    -- input ':'
    feedkeys ':'
    schedule(function()
      M.goto_cmdline_window_from_cmdline()
    end)
  end, opts_global)

  map({ 'c' }, { '<c-c>', 'jk', 'kj' }, function()
    M.goto_cmdline_window_from_cmdline()
  end, opts_global)

  map({ 'c' }, '<Esc>', function()
    last_cmd = vim.fn.getcmdline()
    feedkeys '<C-c>'
  end, opts_global)

  map({ 'c' }, '<CR>', function()
    schedule(function()
      feedkeys '<CR>'
      last_cmd = ''
    end)
  end, opts_global)

  --- Setup callbacks to Cmdwindow events that will make this plugin work
  setup_autocommands()
end

return M
