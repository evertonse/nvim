local M = {}

--- Short names and Helpers
local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local input = vim.api.nvim_input
local schedule = vim.schedule
local schedule_wrap = vim.schedule_wrap

local opts_global = { noremap = true, silent = true }

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

local clamp = function(value, min, max)
  if value < min then
    return min
  elseif value > max then
    return max
  else
    return value
  end
end

local getpos = function()
  return vim.api.nvim_win_get_cursor(0)
end

local setpos = function(pos)
  vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] })
end

local feedkeys = function(keys, behaviour)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), behaviour or 'n', false)
end

local is_in_cmdline = function()
  --- Returns an empty string when not in the command-line window.
  local in_cmdline_window = vim.fn.getcmdwintype() ~= ''
  return vim.api.nvim_get_mode().mode == 'c' and in_cmdline_window and vim.fn.mode():match '^[/:]' ~= nil
end

--- Last cmd typed but not executed
local last_cmd = ''

--- Not used for now, because this affects usage of ':' from vim.cmd. It's not good when this is triggered from lua code instead of keymaps.
--- And it doesn't seem a way to make this distinction, even if using `vim.on_key`, bummer :/
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
  cmd = {
    data = nil,
    cmdtype = nil,
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

  local hist_count = vim.fn.histnr(vim.fn.getcmdtype()) --- Can be -1 but we're taking a 'max' anyway
  local max_cmd_height = previous.opt.cmdwinheight

  local cmdwinheight_desired = clamp(max_cmd_height, 1, math.max(1, hist_count))

  vim.opt.cmdwinheight = cmdwinheight_desired

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
  vim.opt_local.wrap = false

  -- TODO: Make sure <C-d> and alike doesn't let the cursor misaligned with command-line height
  vim.opt_local.scrolloff = 0
  vim.opt_local.startofline = true

  --- Make hl not able to wrap
  vim.opt_local.whichwrap = 'bs<>[]'
end

local setup_autocommands = function()
  local group = augroup('NormalCmdline', { clear = true })
  --- Restore cmdline if we interrupted previously
  au('CmdlineEnter', {
    pattern = '*',
    group = group,
    callback = function(event)
      local line = vim.fn.getcmdline()
      if should_restore_last_cmd and (line and line:len() == 0 and vim.fn.getcmdtype() == ':') then
        vim.fn.setcmdline(previous.cmd.data)
      else
        if previous.cmd.data and previous.cmd.data ~= '' then
          vim.fn.histadd(':', previous.cmd.data)
        end
      end
    end,
  })

  --- Where all the magic happens triggered by simply going into cmdwin
  au('CmdwinEnter', {
    group = group,
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

      map({ 'c' }, '<Esc>', function()
        M.goto_cmdline_window_from_cmdline()
      end, opts_global)

      au('CmdlineLeave', {
        once = true,
        group = group,
        callback = function(event)
          map({ 'c' }, '<Esc>', function()
            previous.cmd.data = vim.fn.getcmdline()
            feedkeys '<C-c>'
          end, opts_global)
        end,
      })

      au({ 'CmdwinLeave', 'WinEnter' }, {
        once = true,
        group = group,
        callback = function(event)
          if previous.restored then
            return
          end
          restore_opts()
        end,
      })

      au('ModeChanged', {
        pattern = '*:[i]*', -- Insert mode
        group = group,
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
      map({ 'n' }, { '<Esc>', '<C-w>k' }, function()
        if save_in_normal_mode then
          previous.cmd.data = vim.fn.getline '.'
        end
        vim.cmd [[stopinsert]]
        vim.cmd [[q!]]
      end, opts)

      map({ 'x', 'v', 'n' }, '<CR>', function()
        feedkeys '<CR>'
        schedule(function()
          previous.cmd.data = ''
        end)
      end, opts)
    end,
  })
end

M.goto_cmdline_window_from_cmdline = function()
  save_opts()
  schedule(function()
    input '<c-f>'
  end)
end

M.setup = function()
  local _ = false -- Not necessary for. But if any problems occurs I'll leave the code for easy options setting
    and schedule(function()
      vim.opt.cmdwinheight = 1
      vim.opt.cmdheight = 1
      vim.opt.more = false
      vim.opt.showcmd = false
      vim.opt.showmode = false
      vim.opt.showcmdloc = 'last'
      vim.opt.shortmess:append 'saAtilmnrxwWoOtTIFcC' -- flags to shorten vim messages, see :help 'shortmess'
      vim.opt.shortmess:append 'c' -- don't give |ins-completion-menu| messages
    end)

  --- Override they keys we need to make it work
  map({ 'n' }, 'q:', function(args)
    -- input ':'
    input ':'
    -- schedule(function()
    M.goto_cmdline_window_from_cmdline()
    -- end)
  end, opts_global)

  map({ 'c' }, { '<c-c>', 'jk', 'kj' }, function()
    M.goto_cmdline_window_from_cmdline()
  end, opts_global)

  map({ 'c' }, '<Esc>', function()
    previous.cmd.data = vim.fn.getcmdline() or ''
    feedkeys '<C-c>'
  end, opts_global)

  map({ 'c' }, '<CR>', function()
    schedule(function()
      feedkeys '<CR>'
      previous.cmd.data = ''
    end)
  end, opts_global)

  --- Setup callbacks to Cmdwindow events that will make this plugin work
  setup_autocommands()
end

return M
