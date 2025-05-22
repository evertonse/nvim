--
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
--  See :map <leader> to show all keymappings starting with the leader key
--
--

local M = {}
local term_opts = { silent = true }
local noremap_opts = { noremap = true, silent = true, nowait = true }
local wait_opts = { noremap = true, silent = true, nowait = false }

FULLSCREEN = false

local substitute = '%s' -- default
-- local substitute = '%S' -- timpope
-- local substitute = 'Subs' -- text-case.nvim

-- Define a table to store previous positions
local function vim_cmd_switch_buffer()
  vim.cmd 'set nomore | ls | set more | b '
end

local switch_buffer = false
  -- or [[:set nomore <Bar> :ls <Bar> :set more <CR>:b<Space><left><right>]]
  -- or '<cmd> Telescope buffers initial_mode=normal<CR>'
  or '<cmd> Telescope buffers initial_mode=insert<CR>'
  or vim_cmd_switch_buffer

-- Close all windows except the current one
local function close_other_windows()
  local current_win = vim.api.nvim_get_current_win()
  local windows = vim.api.nvim_list_wins()

  for _, win in ipairs(windows) do
    if win ~= current_win then
      vim.api.nvim_win_close(win, true)
    end
  end
end

-- Function to jump within the current buffer
local function spelltoggle()
  if vim.opt.spell:get() then
    vim.opt_local.spell = false
    vim.opt_local.spelllang = 'en'
  else
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { 'en_us' }
  end
end

local function delete_scoped_buffer(buf)
  local scope = require 'scope.core'
  scope.close_buffer {
    delete_function = function()
      vim.cmd [[Bdelete!]]
    end,
  }
end

local function close_buffers_by_operation(operation)
  local current_buf = vim.api.nvim_get_current_buf()
  local current_tab = vim.api.nvim_get_current_tabpage()

  require('scope.core').revalidate() -- Gotta fill the cache
  local buffers = require('scope.utils').get_valid_buffers() or require('scope.core').cache[current_tab]
  local ok = function(_)
    return false
  end

  if operation == 'all' then
    ok = function(buf)
      return buf ~= current_buf
    end
  elseif operation == 'right' then
    ok = function(buf)
      return buf > current_buf
    end
  elseif operation == 'left' then
    ok = function(buf)
      return buf < current_buf
    end
  end

  for i, buf in ipairs(buffers) do
    if ok(buf) then
      -- Check if the buffer is listed and loaded before deleting
      vim.api.nvim_buf_set_option(buf, 'buflisted', false)
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
        table.remove(require('scope.core').cache[current_tab], i)
        -- vim.api.nvim_buf_delete(buf, {})
      end
    end
  end
  require('scope.core').revalidate()
end

-- add this table only when you want to disable default keys
-- TIPS `:map <key>` to see all keys with that prefix

local function delete_buffer()
  delete_scoped_buffer()
end

local function is_floating_window()
  local win_id = vim.api.nvim_get_current_win()
  local win_info = vim.api.nvim_win_get_config(win_id)
  return win_info.relative ~= ''
end

-- Function to reopen the most recently saved buffer path
local function reopen_last_buffer()
  local last_buffer_path = table.remove(BufferPaths)
  if last_buffer_path then
    vim.cmd('edit ' .. last_buffer_path)
  else
    print 'No buffer to reopen'
  end
end

local current_buffer_file_extension = function()
  local extension = vim.fn.expand '%:e'
  return extension
end

local handle_k = function()
  local mode = vim.api.nvim_get_mode().mode
  if vim.v.count == 0 and mode ~= 'n' and mode ~= 'no' then
    return 'gk'
  else
    return 'k'
  end
end

local handle_j = function()
  local mode = vim.api.nvim_get_mode().mode
  if vim.v.count == 0 and mode ~= 'n' and mode ~= 'no' then
    return 'gj'
  else
    return 'j'
  end
end

local scratch = function()
  vim.ui.input({ prompt = 'enter command: ', completion = 'command' }, function(input)
    if input == nil then
      return
    elseif input == 'scratch' then
      input = "echo('')"
    end
    local cmd = vim.api.nvim_exec2(input, { output = true })
    local output = {}
    for line in cmd:gmatch '[^\n]+' do
      table.insert(output, line)
    end
    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
    vim.api.nvim_win_set_buf(0, buf)
  end)
end

M.disabled = {
  i = {
    ['<C-h>'] = '',
    ['<C-l>'] = '',
    ['<C-j>'] = '',
    ['<C-k>'] = '',
    ['<Tab>'] = '',
    ['<S-Tab>'] = '',
    ['<C-<space>>'] = '',
  },
  n = {
    ['<C-a>'] = '',
    ['gcc'] = '',
    ['gc'] = '',
    ['<C-<Space>>'] = '',
    ['K'] = '', -- does't work disable search for `man` pages, too slow
    ['<leader>D'] = '',
    ['<leader>'] = '',
    ['<S-tab>'] = '',
    ['<Tab>'] = '',
    ['<C-n>'] = '',
    ['<leader>fo'] = '',
    ['<leader>fa'] = '',
    ['<leader>fb'] = '',
    ['<leader>fc'] = '',
    ['<leader>fd'] = '',
    ['<leader>fe'] = '',
    ['<leader>ff'] = '',
    ['<leader>fg'] = '',
    ['<leader>fh'] = '',
    ['<leader>fi'] = '',
    ['<leader>fj'] = '',
    ['<leader>fl'] = '',
    ['<leader>fm'] = '',
    ['<leader>fn'] = '',
    ['<leader>fq'] = '',
    ['<leader>fr'] = '',
    ['<leader>fs'] = '',
    ['<leader>ft'] = '',
    ['<leader>fu'] = '',
    ['<leader>fv'] = '',
    ['<leader>fx'] = '',
    ['<leader>fz'] = '',
    ['<leader>/'] = '',

    ['<leader>ph'] = '',
    ['<leader>pt'] = '',
    -- copy whole file c-c
    ['<C-c>'] = '',
    ['<leader><C-A>'] = '',
    ['<leader>ch'] = '',
    ['<leader>ca'] = '',
    ['<leader>cc'] = '',
    -- which-key
    ['<leader>wK'] = '',
    ['<leader>wr'] = '',
    ['<leader>wa'] = '',
    ['<leader>wk'] = '',
    ['<leader>fp'] = '',
    ['<leader>wl'] = '',

    ['<leader>fw'] = '',
    ['<leader>tk'] = '',
    -- bufferline
    ['<leader>x'] = '',
    ['<S-b>'] = '',
    -- lspconfig
    [']d'] = '',
    ['[d'] = '',
    ['<leader>gt'] = '',
    ['<leader>cm'] = '',
    -- nvterm
    ['<leader>h'] = '',
    ['<leader>v'] = '',
    ['<A-i>'] = '',
    ['<A-h>'] = '',
    ['<A-v>'] = '',
    -- nvimtree
    ['<leader>e'] = '',
    -- bufferline
    ['<leader>b'] = '',

    ['<leader>l'] = '',
  },
  xvo = {
    -- comment
    ['gc'] = '',
    ['<leader>/'] = '',
    ['<M-Down'] = '',
    ['<leader>'] = '',
  },
  t = {
    -- nvterm
    ['<A-i>'] = '',
    ['<A-h>'] = '',
    ['<A-v>'] = '',
  },
}

local recording = false
function ToggleRecording()
  local opts = { noremap = true, silent = true }
  local map = vim.keymap.set

  if recording then
    recording = false

    vim.cmd 'normal! q'
    vim.cmd "echo ''"
    vim.cmd 'redraw'

    vim.api.nvim_echo({ { 'recording stopped', 'Normal' } }, false, {})
    map({ 'n' }, 'q', '@q', opts)
  else
    recording = true
    vim.cmd 'redraw'
    vim.cmd 'normal! qq'

    map({ 'n' }, 'q', '<nop>', {})

    vim.api.nvim_echo({ { 'recording started', 'Normal' } }, false, {})
  end
end

local change_key_value_on_press = function()
  vim.cmd [[
    nnoremap @{ :nmap ; @}<CR>qq
    nnoremap @} q:nmap ; @{<CR>

    " Toggle recording
    nmap Q @{

    " Playback
    nnoremap gq @q
  ]]
end

local last_terminal_mode = 'i'

local grep_and_show_results = function()
  local patterns = {}
  local file_extension = current_buffer_file_extension()
  local current_word = vim.fn.expand '<cword>'
  if file_extension == 'odin' then
    table.insert(patterns, current_word .. '.*:.*:')
    table.insert(patterns, current_word .. '.*:.*=')
    table.insert(patterns, current_word .. '.*:.*$')
    table.insert(patterns, current_word .. '.*:.*;')
  else
    table.insert(patterns, current_word)
  end

  local results = {}
  local gg = 'grep -RrEinIH '
  local case_sensitive = true
  if case_sensitive then
    gg = 'grep -RrEnIH '
  end

  for _, pattern in ipairs(patterns) do
    local result = vim.fn.systemlist(gg .. vim.fn.shellescape(pattern))
    table.insert(results, result)
    -- Check if there are any results
  end
  if #results == 0 then
    print 'No results found.'
    return
  end

  local seen_entries = {}
  -- Prepare quickfix list entries
  local quickfix_list = {}
  for _, result in ipairs(results) do
    for _, line in ipairs(result) do
      local file_name, line_number, content = line:match '(.+):(%d+):(.+)'
      local entry_key = file_name .. ':' .. (line_number or '')

      local found_file_extension = vim.fn.fnamemodify(file_name, ':e')
      local allowed_extension = vim.tbl_contains({ found_file_extension }, file_extension)
      if file_name and line_number and content and allowed_extension then
        -- Check if the entry has been seen before
        if not seen_entries[entry_key] then
          table.insert(quickfix_list, {
            filename = file_name,
            lnum = tonumber(line_number),
            text = content,
          })
          seen_entries[entry_key] = true
        end
      end
    end
  end

  -- Set the quickfix list
  vim.fn.setqflist(quickfix_list)

  -- Open the quickfix window
  vim.cmd 'horizontal copen'
  -- -- Close the quickfix window after setting the list
  -- vim.cmd "cclose"
end

local float_term = {
  terminal = nil,
  width_percentage = 0.60,
  height_percentage = 0.65,
  width_min = 70,
  height_min = 23,
}
local function switch_to_non_floating_buffer()
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(current_win)

  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    if win ~= current_win then
      local win_info = vim.api.nvim_win_get_config(win)
      if win_info.relative == '' then
        -- Switch to the first non-floating window found
        vim.api.nvim_set_current_win(win)
        return
      end
    end
  end
end

local float_term_get_or_create = function()
  local ok, tt = pcall(require, 'toggleterm.terminal')
  if not ok then
    return
  end

  local f = float_term
  f.terminal = f.terminal
    or tt.Terminal:new {
      direction = 'float',
      float_opts = {
        width = math.floor(vim.o.columns * f.width_percentage),
        height = math.floor(vim.o.lines * f.height_percentage),
      },
      on_open = function(term) ---@diagnostic disable-line: unused-local
        vim.cmd 'startinsert!'
      end,
    }
  f.terminal.float_opts.width = math.max(f.width_min, math.floor(vim.o.columns * f.width_percentage))
  f.terminal.float_opts.height = math.max(f.height_min, math.floor(vim.o.lines * f.height_percentage))
  return f
end

local float_term_toggle = function()
  local tt, ok = pcall(require, 'toggleterm.terminal')
  if not ok then
    return
  end

  local f = float_term_get_or_create()
  f.terminal:toggle()
end

local float_term_rerun_cmd = function()
  local ok, tt = pcall(require, 'toggleterm.terminal')
  if not ok then
    return
  end
  local first_open = float_term.terminal == nil
  local f = float_term_get_or_create()

  if not f.terminal:is_open() then
    f.terminal:open()
  end

  f.terminal:focus()
  vim.schedule(function()
    if first_open then
      -- Hackish as mofo, like it takes some time for my zshrc to load so before it loads
      -- nothing we send will go through XDDD
      -- 190 is def too little time, go on from there
      vim.wait(250)
    end
    vim.cmd [[startinsert]]

    -- Clear shell prompt line (works in bash and sh)
    vim.api.nvim_chan_send(f.terminal.job_id, '\x15') -- <C-u> in ASCII
    vim.api.nvim_chan_send(f.terminal.job_id, '\x0b') -- <C-k>
    -- Method terminal:send was bugged in a previous version of toggleterm, didn't send the '\n'.
    -- So we're using lower lever api 'vim.api.nvim_chan_send'
    -- f.terminal:send '!!'
    vim.api.nvim_chan_send(f.terminal.job_id, '!!\n')
  end)
end

local float_term_run_selection = function()
  local tt, ok = pcall(require, 'toggleterm.terminal')
  if not ok then
    return
  end
  local tt = require 'toggleterm'

  local selection = GetVisualSelection { register = 'a', escape = { enabled = false, parens = false, brackets = false } }

  local first_open = float_term.terminal == nil
  local f = float_term_get_or_create()
  if not f.terminal:is_open() then
    f.terminal:open()
  end
  f.terminal:focus()

  vim.schedule(function()
    -- local first_open = float_term.terminal == nil
    if first_open then
      -- Hackish as mofo, like it takes some time for my zshrc to load so before it loads
      -- nothing we send will go through XDDD
      -- 190 is def too little time, go on from there
      vim.wait(250)
    end
    -- clear_terminal_scrollback doenst work
    -- vim.api.nvim_chan_send(f.terminal.job_id, '\027c')

    -- vim.wait(225)
    vim.cmd [[startinsert]]

    -- Clear shell prompt line (works in bash and sh)
    vim.api.nvim_chan_send(f.terminal.job_id, '\x15') -- <C-u> in ASCII
    vim.api.nvim_chan_send(f.terminal.job_id, '\x0b') -- <C-k>

    -- Supposedly vim.fn functions have more overhead because it does through vim script  i believe; api.nvim_* fuinction are preferred.
    -- vim.fn.chansend(f.terminal.job_id, '\x15')

    -- f.terminal:send(selection)
    vim.api.nvim_chan_send(f.terminal.job_id, selection .. '\n') -- newline triggers execution

    -- vim.api.nvim_input '<CR>'
  end)
end

if OnWindows() then
  float_term_rerun_cmd = function()
    vim.print 'Go fuck yourself, u be tryina use terminals on windows ? Get a life'
  end
end

M.general = {
  -- [TERMINAL and NORMAL]
  tn = {},

  tni = {
    ['<F5>'] = {
      function()
        float_term_rerun_cmd()
      end,
      'Rerun floating terminal',
    },
  },

  snovx = {
    ['<A-q>'] = { '/', "I'm too used to Alt + q being search", { expr = false } },
    ['Q'] = { 'q', 'annoying that `q` is quit but also record ??', { expr = false } },
    ['q'] = { '', 'annoying that `q` is quit but also record ??', { expr = false } },
    ['gh'] = { '^', 'Move backwards until previous is space', { expr = false } },
    ['gl'] = { 'g_', 'Move forwards until next is space', { expr = false } },

    ['H'] = { '0', 'Move backwards until previous is space', { expr = false } },
    ['L'] = { '$', 'Move forwards until next is space', { expr = false } },
    -- ['gh'] = { '0', 'Move big left', { expr = false } },
    -- ['gl'] = { '$', 'Move big right', { expr = false } },
    ['gH'] = { 'v:count || mode(1)[0:1] == "" ? "0" : "g0"', 'Move left', { expr = true } },
    ['gL'] = { 'v:count || mode(1)[0:1] == "no" ? "$" : "g$"', 'Move right', { expr = true } },
  },
  vx = {
    ['<F5>'] = {
      function()
        float_term_run_selection()
      end,
      'Rerun floating terminal',
    },
    ['<leader>rw'] = {
      [[ygv<esc>:]] .. substitute .. [[/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left><Space><BS><Down>]],
      '[R]eplace [W]ord',
    },

    [';'] = { ':<Down><Down>', 'Command Mode' },
    -- ['<C-\\>'] = {
    --   function()
    --     vim.api.nvim_input ':<Down><C-f>'
    --   end,
    -- },
  },

  csi = {

    ['<S-Tab>'] = { '<C-d>', 'Reverse Tab' },
    -- go to  beginning and end
    ['<C-e>'] = { '<End>', 'End of line' },
    -- ['<S-<Tab>>'] = { '<C-o>dd', '' },

    -----------------------------------------------------
    --- remap key to output symbols easier ininsert mode
    -----------------------------------------------------
    ['<C-b>'] = { '<ESC>^i', 'Beginning of line' },
    ['<C-h>'] = {
      function()
        vim.api.nvim_input '_'
      end,
      '',
    },
    ['<C-j>'] = {
      function()
        vim.api.nvim_input '='
      end,
      '',
    },
    ['<C-k>'] = {
      function()
        vim.api.nvim_input '<C-k>'
      end,
      '',
    },
    ['<C-l>'] = {
      function()
        vim.api.nvim_input '*'
      end,
      '',
    },
    ['<C-g>'] = {
      function()
        vim.api.nvim_input '&'
      end,
      '',
    },
    ------------------------------------
  },

  -- [CMDLINE]
  c = {
    -- ['<C-k>'] = {
    --   function()
    --     vim.api.nvim_input '<Up>'
    --   end,
    -- },
    -- ['<C-j>'] = {
    --   function()
    --     vim.api.nvim_input '<Down>'
    --   end,
    -- },
  },

  -- [NORMAL]
  n = {

    ['<leader>Q'] = { close_other_windows, 'Close all other windows' },
    ['<leader>b'] = { switch_buffer, 'Find buffers' },
    ['<leader>hy'] = { ':YankHistory <CR>', '[H]istory [Y]ank' },
    ['<leader>5'] = { spelltoggle, '5 for [5]pell Toggle' },

    ['<leader>zz'] = {
      function()
        vim.cmd [[setlocal spell spelllang=en_us]]
        -- Next
        -- vim.api.nvim_input '[s1z=``'
        vim.api.nvim_input '1z='
        vim.schedule(function()
          vim.cmd [[setlocal spelllang=]]
        end)
      end,
      'Correct [Z]peling Mistakes',
    },
    ['<leader>zg'] = {
      function()
        vim.cmd [[setlocal spell spelllang=en_us]]
        vim.api.nvim_input 'zg'
        vim.schedule(function()
          vim.cmd [[setlocal spelllang=]]
        end)
      end,
      '',
    },
    ['<leader>z='] = {
      function()
        vim.cmd [[setlocal spell spelllang=en_us]]
        -- Next
        vim.api.nvim_input 'z=]s'
        vim.schedule(function()
          vim.cmd [[setlocal spelllang=]]
        end)
      end,
      'Correct [Z]peling Mistakes',
    },

    ['<Esc>'] = { '<cmd>noh <CR>', 'Clear highlights' },

    -->> ToggleTerm
    ['<A-i>'] = {
      function()
        float_term_toggle()
        --vim.cmd [[startinsert]]
      end,
      'Toggle floating terminal',
    },

    ['<leader>rw'] = {
      [[:]] .. substitute .. [[/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left><Space><BS>]],
      '[R]eplace [W]ord',
    },
    ['<leader>e'] = {
      function()
        require('functions').tree_toggle { focus_file = false }
      end,
      'Toggle neo tree',
    },
    ['<leader>E'] = {
      function()
        require('functions').tree_toggle { focus_file = true }
      end,
      'Toggle neo tree',
    },

    -->> NNN picker
    -- ['<leader>e'] = { '<cmd> NnnPicker <CR>', 'NNN Floating Window' },
    -- ['<leader>lr'] = {
    --   function()
    --     return ':IncRename ' .. vim.fn.expand '<cword>'
    --   end,
    --   { expr = true },
    -- },

    ['<M-b>'] = {
      function()
        vim.api.nvim_input [[:set nomore <CR> :ls <CR> :set more <CR>:b<Space>]]
      end,
      noremap_opts,
    }, -- NOTE:This is remaped when lsp is present

    -->> commands
    ['<leader>gd'] = { grep_and_show_results, noremap_opts }, -- NOTE:This is remaped when lsp is present
    -- ['gf'] = { 'gFzz', noremap_opts },

    ['<C-o>'] = { '<C-o>zz', noremap_opts },
    ['<C-i>'] = { '<C-i>zz', noremap_opts },
    ['<leader>tn'] = { ':tabn <CR>', noremap_opts },
    ['<leader>tp'] = { ':tabp<CR>', noremap_opts },
    ['<leader>tt'] = { ':tab split<CR>', noremap_opts },
    ['<leader>tc'] = { ':tabc<CR>', noremap_opts },

    -->> Window
    ['<leader>sc'] = {
      scratch,
      'this works like file navigation except that if there is no terminal at the specified index a new terminal is created.',
    },
    -->> Harpoon A-o is more ergonomic
    ['<A-o>'] = {
      function()
        if vim.bo.buftype == 'terminal' then
          last_terminal_mode = vim.fn.mode()
          -- vim.cmd "bp"
          vim.api.nvim_input '<C-o>'
          -- vim.cmd [[call feedkeys("<C-o>")]]
        else
          -- vim.api.nvim_input "mM" -- Might be useful to know this cmd exists later
          require('harpoon.term').gotoTerminal(1)
          if vim.g.self.terminal_always_insert then
            vim.cmd 'startinsert'
          else
            if last_terminal_mode == 'i' then
              vim.cmd 'startinsert'
            end
          end
        end
      end,
      'this works like file navigation except that if there is no terminal at the specified index a new terminal is created.',
    },
    ['<leader>ha'] = {
      function()
        require('harpoon.mark').add_file()
        print 'harpoon mark added'
      end,
      '[H]arpoon [A]dd mark',
    },
    ['<leader>hr'] = {
      function()
        require('harpoon.mark').rm_file 'harpoon mark removed'
      end,
      '[H]arpoon [R]emove mark',
    },
    -- ["<A-b>"]         = { ":Telescope harpoon marks initial_mode=normal <CR>", "this works like file navigation except that if there is no terminal at the specified index a new terminal is created." },
    ['<leader>hh'] = {
      function()
        require('harpoon.ui').toggle_quick_menu()
      end,
      '[H]arpoon [B]uffer navigation',
    },
    ['<A-n>'] = {
      function()
        require('harpoon.ui').nav_next()
      end,
      '-- navigates to next mark',
    },
    ['<A-p>'] = {
      function()
        require('harpoon.ui').nav_prev()
      end,
      '-- navigates to next mark',
    },

    -- @todo close tree if opened
    ["<A-'>"] = {
      function()
        require('harpoon.ui').nav_file(1)
      end,
      '-- navigates to 1',
    },
    ['<A-1>'] = {
      function()
        require('harpoon.ui').nav_file(2)
      end,
      '-- navigates to 1',
    },
    ['<A-2>'] = {
      function()
        require('harpoon.ui').nav_file(3)
      end,
      '-- navigates to 2',
    },
    ['<A-3>'] = {
      function()
        require('harpoon.ui').nav_file(4)
      end,
      '-- navigates to 3',
    },
    ['<A-4>'] = {
      function()
        require('harpoon.ui').nav_file(5)
      end,
      '-- navigates to 4',
    },
    ['<A-5>'] = {
      function()
        require('harpoon.ui').nav_file(5)
      end,
      '-- navigates to 5',
    },
    ['<A-6>'] = {
      function()
        require('harpoon.ui').nav_file(7)
      end,
      '-- navigates to 5',
    },
    ['<A-7>'] = {
      function()
        require('harpoon.ui').nav_file(8)
      end,
      '-- navigates to 5',
    },

    -- >> recorging
    -- ['Q'] = { '@', 'Activate MACRO on q register' },
    -- ["q"]             = { "q", "Activate MACRO on q register" },
    -- ["Q"]             = { ToggleRecording, "Record MACRO on q register" },
    --
    -- ["Q"]             = { "qq", "Record MACRO on q register" },

    ['<leader>xl'] = {
      function()
        close_buffers_by_operation 'right'
      end,
      'close all buffers to the right of current one',
    },
    ['<leader>xh'] = {
      function()
        close_buffers_by_operation 'left'
      end,
      'close all buffers to the left of current one',
    },
    ['<leader>xa'] = {
      function()
        close_buffers_by_operation 'all'
      end,
      'close all buffers expect current one',
    },

    -- Open Cmdline Window
    -- ['Q'] = { '<cmd> q:<CR>', 'Open Cmdline Window' },

    -- Copy all
    ['<leader><C-y>'] = { '<cmd> %y+ <CR>', 'Copy whole file' },

    -- Neotree git status
    ['<leader>ng'] = { '<cmd>Neotree git_status <CR>', 'Show git status' },
    ['<leader>nb'] = { '<cmd>Neotree buffers <CR>', 'Show Buffers opened' },
    ['<leader>nc'] = { '<cmd>Neotree current <CR>', ' : Open within the current window, like netrw or vinegar would.' },

    -- line numbers
    ['<leader>rn'] = { '<cmd> set rnu! <CR>', 'Toggle relative number' },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ['k'] = { handle_k, 'Move up', { expr = true } },
    ['j'] = { handle_j, 'Move down', { expr = true } },
    ['<Up>'] = { handle_k, 'Move up', { expr = true } },
    ['<Down>'] = { handle_j, 'Move down', { expr = true } },

    -- new buffer
    ['<C-w>f'] = {
      function()
        if FULLSCREEN then
          FULLSCREEN = false
          vim.cmd [[tabc]]
        else
          vim.cmd [[tab split]]
          FULLSCREEN = true
        end
      end,
      'New buffer',
    },
    ['<M-Up>'] = { 'ddkP', noremap_opts }, --// Moving the line up
    ['<M-Down>'] = { 'ddjP', noremap_opts }, -- // Moving the line down
    ['<M-[>'] = { ':resize -2<CR>', noremap_opts },
    ['<M-]>'] = { ':resize +2<CR>', noremap_opts },
    ['<M-,>'] = { ':vertical resize -2<CR>', noremap_opts },
    ['<M-.>'] = { ':vertical resize +2<CR>', noremap_opts },
    ['<C-w-,>'] = { ':vertical resize -2<CR>', noremap_opts },
    ['<C-w-.>'] = { ':vertical resize +2<CR>', noremap_opts },
    -- Navigate buffers
    --- behave like other capitals

    ['Y'] = { 'y$', noremap_opts },
    -- >> Clip Board option
    ['<leader>y'] = { '"+y', noremap_opts },
    ['<leader>Y'] = { '"+y$', noremap_opts },
    ['<leader>p'] = { '"+p', noremap_opts },
    ['<leader>P'] = { '"+P', noremap_opts },

    -- ['<S-l>'] = { '<cmd>bnext<CR>', noremap_opts },
    -- ['<S-h>'] = { '<cmd>bprevious<CR>', noremap_opts },

    ['<C-l>'] = { '<cmd>bnext<CR>', noremap_opts },
    ['<C-h>'] = { '<cmd>bprevious<CR>', noremap_opts },

    -- Move text up and down
    ['<A-j>'] = { '<Esc>:m .+1<CR>==', noremap_opts },
    ['<A-k>'] = { '<Esc>:m .-2<CR>==', noremap_opts },

    ['<C-Left>'] = { 'b', noremap_opts },
    ['<C-Right>'] = { 'e', noremap_opts },

    ['<C-j>'] = { '}', noremap_opts },
    ['<C-k>'] = { '{', noremap_opts },

    ['<leader>w'] = { '<cmd>w<CR>', noremap_opts },
    ['<leader>q'] = { '<cmd>q<CR>', noremap_opts },
    ['<leader>c'] = { delete_buffer, noremap_opts },
    ['<leader>C'] = { reopen_last_buffer, noremap_opts },
    -- ["<leader>c"]     = { ":bd!<CR>",  noremap_opts },

    ['<C-Up>'] = { '{', noremap_opts },
    ['<C-Down>'] = { '}', noremap_opts },
    -- >> Shift Selection :
    ['<S-Up>'] = { 'v<Up>', noremap_opts },
    ['<S-Down>'] = { 'v<Down>', noremap_opts },
    ['<S-Left>'] = { '<Left>v', noremap_opts },
    ['<S-Right>'] = { 'v', noremap_opts },
    ['<M-Left>'] = { '<C-o>', noremap_opts },
    ['<M-Right>'] = { '<C-i>', noremap_opts },
    ['<C-d>'] = { '<C-d>zz', noremap_opts },
    ['<C-u>'] = { '<C-u>zz', noremap_opts },
    ['n'] = { 'nzzzv', noremap_opts },
    ['N'] = { 'Nzzzv', noremap_opts },
    ['J'] = { 'mzJ`z', noremap_opts },

    ['U'] = { '<C-r>zv', noremap_opts },
    ['u'] = { 'uzv', noremap_opts },

    -- TODO: Make this using GetVisualSelection  instead, for better escaping
    ['<leader>re'] = { [[:]] .. substitute .. [[///g<Left><Left><Left><Down>]], noremap_opts },

    ['<leader>d'] = { '"_d', noremap_opts },
    ['<leader>D'] = { '"_D', noremap_opts },
    --["<leader>p"]      = { '"_p',  noremap_opts },
    ['x'] = { '"_x', noremap_opts },
    -- ['s'] = { '"_s', noremap_opts }, -- Were using surround so this key must go
    -- ['ge'] = { 'G', noremap_opts },
  },

  i = {
    -- Insert --

    -- Press jk fast to exit insert mode
    -- ['jk'] = { '<ESC>', noremap_opts },
    -- ['kj'] = { '<ESC>', noremap_opts },
    ['<C-Up>'] = { '<C-o>{', noremap_opts },
    ['<C-Down>'] = { '<C-o>}', noremap_opts },
    ['<C-Left>'] = { '<C-o>b', noremap_opts },
    ['<C-Right>'] = { '<C-o>e<Right>', noremap_opts },
    ['<C-v>'] = { '<C-o><C-v>', noremap_opts },
    -- << Move fast with crtl move,
    ['<S-Up>'] = { '<C-o>v<Up>', noremap_opts },
    ['<S-Down>'] = { '<C-o>v<Down>', noremap_opts },
    ['<S-Left>'] = { '<Left><C-o>v', noremap_opts },
    ['<S-Right>'] = { '<C-o>v', noremap_opts },
    ['<M-U>'] = { '<C-o><C-r>' },
  },
  -- Visual --
  v = {
    ['//'] = { 'y/<C-R>"<CR>', 'Search for highlighted text' },
    ['<leader>re'] = {
      function()
        TextPostDontTrigger = true
        local mode = vim.api.nvim_get_mode().mode

        -- Check if we are in Visual mode (including Visual Line and Visual Block)
        if mode == 'V' or mode == '\22' then
          -- Below we're using normal S beware
          -- vim.api.nvim_input [[<cmd>s///gc<left><left><left><left>]]
          -- vim.api.nvim_input [[:s///gc<left><left><left><left>]]
          vim.api.nvim_input([[:]] .. substitute .. [[///gc<left><left><left><left>]])
          return
        end

        vim.api.nvim_input([["0y:]] .. substitute .. [[/<c-r>0//gc<left><left><left>]])
      end,
      '[R]eplace [W]ord',
    },
    ['<leader>n'] = { '<cmd>norm ', 'normal keys insertion', { expr = true } },

    ['*'] = {
      function()
        TextPostDontTrigger = true

        local mode = vim.api.nvim_get_mode().mode
        -- Check if we are in Visual mode (including Visual Line and Visual Block)

        if mode == 'V' or mode == '\22' then
          -- vim.api.nvim_input [[:s///gc<left><left><left><left>]]
          return
        end
        TextPostDontTrigger = true

        -- TODO: A churimbeta vai xiar com ese get visual selectrion regesitewr clyubering
        local reg = 'a'
        local selection = GetVisualSelection { register = reg, escape = { parens = false, brackets = true } }
        -- vim.api.nvim_input('/' .. '<c-r>' .. reg)
        -- vim.api.nvim_input('/' .. selection)
        vim.api.nvim_feedkeys('/', 'n', false)
        vim.api.nvim_feedkeys(selection or '', 'c', false)
        -- Inspect(selection)
        vim.schedule(function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n', true)
        end)
      end,
      function()
        TextPostDontTrigger = true
      end,
      '',
      { expr = false },
    },

    ['<Up>'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', { expr = true } },
    ['<Down>'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', { expr = true } },

    ['j'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', { expr = true } },
    ['k'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', { expr = true } },

    ['J'] = { ":m '>+1<CR>gv=gv", noremap_opts },
    ['K'] = { ":m '<-2<CR>gv=gv", noremap_opts },

    -- Stay in indent mode
    ['<'] = { '<gv', noremap_opts },
    ['>'] = { '>gv', noremap_opts },

    -- Move text up and down
    ['<A-j>'] = { ":m '>+1<CR>gv=gv", noremap_opts },
    ['<A-k>'] = { ":m '<-2<CR>gv=gv", noremap_opts },

    ['p'] = { 'P', noremap_opts },
    -- ['P'] = { '"_P', noremap_opts }, -- This one is wrong strangely

    ['<C-h>'] = { 'b' },
    ['<C-l>'] = { 'e' },

    ['<C-Left>'] = { 'b' },
    ['<C-Right>'] = { 'e' },

    ['<C-j>'] = { '}', noremap_opts },
    ['<C-k>'] = { '{', noremap_opts },

    ['<C-Up>'] = { '{', noremap_opts },
    ['<C-Down>'] = { '}', noremap_opts },

    ['<M-Up>'] = { ":m '<-2<CR>gv=gv", noremap_opts },
    ['<M-Down>'] = { ":m '>+2<CR>gv=gv", noremap_opts },

    ['<A-Up>'] = { ":move '<-2<CR>gv-gv", noremap_opts },

    ['<S-Up>'] = { '<Up>', noremap_opts },
    ['<S-Down>'] = { '<Down>', noremap_opts },
    ['<S-Left>'] = { '<Left>', noremap_opts },
    ['<S-Right>'] = { '<Right>', noremap_opts },
    -- << Shift Selection :
    ['<leader>d'] = { '"_d', noremap_opts },
    ['<leader>D'] = { '"_D', noremap_opts },
    -- Clip board
    ['<leader>y'] = { '"+y', noremap_opts },
    ['<leader>Y'] = { '"+y$', noremap_opts },

    ['x'] = { '"_x', noremap_opts },
    ['c'] = { '"_c', noremap_opts = { noremap = true, silent = true, nowait = true, expr = true } },
    ['ge'] = { 'G', noremap_opts },
    ['<leader>s'] = { '"_s', noremap_opts },

    ['<leader>p'] = { '"+p', noremap_opts },
    ['<leader>P'] = { '"+P', noremap_opts },
  },
  x = {
    ['<Up>'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', { expr = true } },
    ['<Down>'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', { expr = true } },
    -- Search inside visually highlighted text. Use `silent = false` for it to
    -- make effect immediately.

    -- Search visually selected text (slightly better than builtins in
    -- Neovim>=0.8 but slightly worse than builtins in Neovim>=0.10)
    -- TODO: Remove this after compatibility with Neovim=0.9 is dropped

    ['j'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', { expr = true } },
    ['k'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', { expr = true } },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ['p'] = { 'p:let @+=@0<CR>:let @"=@0<CR>', 'Dont copy replaced text', { silent = true } },

    ['J'] = { ":move '>+1<CR>gv-gv", noremap_opts },
    ['K'] = { ":move '<-2<CR>gv-gv", noremap_opts },
    ['<A-j>'] = { ":move '>+1<CR>gv-gv", noremap_opts },
    ['<A-k>'] = { ":move '<-2<CR>gv-gv", noremap_opts },
    ['<A-Down>'] = { ":move '>+1<CR>gv-gv", noremap_opts },
    ['<Space>'] = { '<Nop>', { silent = true } },

    ['<leader>d'] = { '"_d', noremap_opts },
    ['<leader>D'] = { '"_D', noremap_opts },

    ['<leader>p'] = { '"+p', noremap_opts },
    ['<leader>P'] = { '"+P', noremap_opts },

    ['x'] = { '"_x', noremap_opts },
    ['c'] = { '"_c', noremap_opts },
    ['ge'] = { 'G', noremap_opts },
  },

  t = {
    -->> ToggleTerm
    ['<A-i>'] = {
      function()
        float_term_toggle()
      end,
      'Toggle nvimtree',
    },

    ['<C-x>'] = { vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true, true), 'Escape terminal mode' },
    -- ["<C-c>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal with Crtl + c which my be strange to do since crtl+c already means something" },
    ['<C-f>'] = { vim.api.nvim_replace_termcodes('<C-W>', true, true, true), 'Avance to next word completion in term' },
    ['<C-w>'] = { vim.api.nvim_replace_termcodes('<C-\\><C-w>', false, false, false), 'Escape terminal mode' },
    ['<A-o>'] = {
      function()
        last_terminal_mode = 'i'
        -- vim.cmd "bp"
        vim.cmd [[stopinsert]]
        vim.api.nvim_input '<C-o>'
      end,
    },
    ['<C-w>h'] = { '<C-\\><C-N><C-w>h', term_opts },
    ['<C-w>j'] = { '<C-\\><C-N><C-w>j', term_opts },
    ['<C-w>k'] = { '<C-\\><C-N><C-w>k', term_opts },
    ['<C-w>l'] = { '<C-\\><C-N><C-w>l', term_opts },
    ['<C-w>s'] = { '<C-\\><C-N><C-w>s', term_opts },
    ['<C-w>v'] = { '<C-\\><C-N><C-w>v', term_opts },
    ['<C-o>'] = { '<C-\\><C-N><C-o>', term_opts },
  },
}

M.tabufline = {
  plugin = true,

  n = {
    -- cycle through buffers
    -- ["<S-l>"] = {
    --   function()
    --     require("nvchad_ui.tabufline").tabuflineNext()
    --   end,
    --   "Goto next buffer",
    -- },
    --
    -- ["<S-h>"] = {
    --   function()
    --     require("nvchad_ui.tabufline").tabuflinePrev()
    --   end,
    --   "Goto prev buffer",
    -- },
    --
    -- -- close buffer + hide terminal buffer
    -- ["<leader>c"] = {
    --   function()
    --     require("nvchad_ui.tabufline").close_buffer()
    --   end,
    --   "Close buffer",
    -- },
  },
}

M.comment = {
  plugin = true,

  -- toggle comment in both modes
  n = {
    ['<leader>/'] = {
      function()
        require('Comment.api').toggle.linewise.current()
      end,
      'Toggle comment',
    },
  },

  v = {
    ['<leader>/'] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      'Toggle comment',
    },
  },
}

M.lspconfig = {
  plugin = true,

  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

  n = {
    ['gD'] = {
      function()
        vim.lsp.buf.declaration()
      end,
      'LSP declaration',
    },

    ['gd'] = {
      function()
        vim.lsp.buf.definition()
      end,
      'LSP definition',
    },

    ['K'] = {
      function()
        vim.lsp.buf.hover()
      end,
      'LSP hover',
    },

    ['gi'] = {
      function()
        vim.lsp.buf.implementation()
      end,
      'LSP implementation',
    },

    ['<leader>ls'] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      'LSP signature help',
    },

    ['<leader>gtd'] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      'LSP [g]o to [t]ype [d]efinition',
    },

    ['<leader>lr'] = {
      function()
        -- require("nvchad_ui.renamer").open()
        vim.lsp.buf.rename()
      end,
      '[L]SP [R]ename',
    },

    ['<leader>lca'] = {
      function()
        vim.lsp.buf.code_action()
      end,
      'LSP code action',
    },

    ['gr'] = {
      function()
        vim.lsp.buf.references()
      end,
      'LSP references',
    },

    ['<leader>lof'] = {
      function()
        vim.diagnostic.open_float { border = 'rounded' }
      end,
      'Floating diagnostic',
    },

    ['[d'] = {
      function()
        vim.diagnostic.goto_prev { float = { border = 'rounded' } }
      end,
      'Goto prev',
    },

    [']d'] = {
      function()
        vim.diagnostic.goto_next { float = { border = 'rounded' } }
      end,
      'Goto next',
    },

    ['<leader>loc'] = {
      function()
        vim.diagnostic.setloclist()
      end,
      'Diagnostic setloclist',
    },

    ['<leader>lf'] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      'LSP formatting',
    },

    ['<leader>lwa'] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      'Add workspace folder',
    },

    ['<leader>lwr'] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      'Remove workspace folder',
    },

    ['<leader>lwl'] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      'List workspace folders',
    },
  },
}

M.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    -- ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
    -- focus

    -- ['<leader>e'] = { '<cmd> NvimTreeToggle <CR>', 'Toggle nvimtree' },
    --["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },
    ['<leader>E'] = { '<cmd> NvimTreeFindFile <CR>', 'Focus Current file' },
  },
}

M['neo-tree'] = {

  n = {
    ['<leader>e'] = { '<cmd> Neotree toggle <CR>', 'Toggle neo tree' },
    ['<leader>E'] = { '<cmd> Neotree reveal_force_cwd<CR>', 'Toggle neo tree' },
  },
}

M.telescope = {
  plugin = true,

  -- Normal and Terminal Mode
  n = {
    --["<leader>f"] = { "<cmd> Telescope find_files <CR>", "Find files" },
    ['<leader>markslocal'] = { '<cmd> :Telescope marks mark_type=local <CR>', 'Find all' },
    ['<leader>af'] = { '<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>', 'Find all' },
    ['<leader>f'] = {
      -- "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
      -- "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'fd', '--type', 'file', '--no-ignore', '--hidden', '--exclude', '.git' }})<cr>",
      "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'fd', '--type', 'file', '--no-ignore', '--hidden', '--exclude', '.git', '--exclude', '__pycache__','--exclude', '.mypy_cache', '--exclude', '.cache', '--exclude', '.vscode', '--exclude', '.idea', '--exclude', '.vs', '--exclude', 'node_modules', '--exclude', 'venv' }})<cr>",
      -- "<cmd>lua require'telescope.builtin'.find_files()<cr>",
    },
    ['<leader>F'] = { '<cmd> Telescope live_grep <CR>', 'Live grep' },
    --- local Functions are considered false value !!?!!

    --["<leader>b"]      = { "<cmd> enew <CR>", "New buffer" },
    ['<leader>tf'] = { '<cmd> Telescope help_tags <CR>', 'Help page' },
    ['<leader>of'] = { '<cmd> Telescope oldfiles <CR>', 'Find oldfiles' },
    ['<leader><C-f>'] = { '<cmd> Telescope current_buffer_fuzzy_find <CR>', '[C]urrent buffer [F]ind ' },

    -- git
    ['<leader>gc'] = { '<cmd> Telescope git_commits <CR>', 'Git commits' },
    ['<leader>gt'] = { '<cmd> Telescope git_status <CR>', 'Git status' },

    -- pick a hidden term
    --["<leader>pt"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },

    -- theme switcher
    ['<leader>th'] = { '<cmd> Telescope themes <CR>', 'Nvchad themes' },

    ['<leader>ma'] = { '<cmd> Telescope marks initial_mode=normal<CR>', 'telescope bookmarks' },
  },
}

M.whichkey = {
  n = {
    ['<leader>WK'] = {
      function()
        vim.cmd 'WhichKey'
      end,
      'Which-key all keymaps',
    },
    ['<leader>Wk'] = {
      function()
        --local input = vim.fn.input "WhichKey: "
        --vim.cmd("WhichKey " .. input)
      end,
      'Which-key query lookup',
    },
  },
}

M.blankline = {}

M.gitsigns = {
  plugin = true,

  n = {
    -- Navigation through hunks
    [']c'] = {
      function()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(function()
          require('gitsigns').next_hunk()
        end)
        return '<Ignore>'
      end,
      'Jump to next hunk',
      { expr = true },
    },

    ['[c'] = {
      function()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(function()
          require('gitsigns').prev_hunk()
        end)
        return '<Ignore>'
      end,
      'Jump to prev hunk',
      { expr = true },
    },

    -- Actions
    ['<leader>rh'] = {
      function()
        require('gitsigns').reset_hunk()
      end,
      'Reset hunk',
    },

    ['<leader>gh'] = {
      function()
        require('gitsigns').preview_hunk()
      end,
      'Preview hunk',
    },

    ['<leader>gb'] = {
      function()
        package.loaded.gitsigns.blame_line()
      end,
      '[G]it [B]lame line',
    },

    ['<leader>td'] = {
      function()
        require('gitsigns').toggle_deleted()
      end,
      'Toggle deleted',
    },
  },
}

M.dap = {
  plugin = true,
  n = {
    ['<leader>db'] = { '<cmd> DapToggleBreakpoint <CR>' },
    ['<F9>'] = { '<cmd> DapToggleBreakpoint <CR>' },
  },
}

M.dap_python = {
  plugin = true,
  n = {
    ['<leader>dpr'] = {
      function()
        require('dap-python').test_method()
      end,
    },
  },
}

M.cmp = {
  plugin = true,
  i = {
    ['<Tab>'] = { '' },
  },
}

-- Diagnostic keymaps

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
-- Function to set keymaps

local setup_marks_to_always_globals = function()
  local function set_global_mark(mark)
    local existing_mark = vim.fn.getpos("'" .. mark)
    -- Check if the mark is already set (line number will be > 0)
    if existing_mark[2] > 0 then
      local buffer_name = vim.fn.bufname(existing_mark[1])
      local line_number = existing_mark[2]
      -- Prompt the user for confirmation
      local response =
        vim.fn.confirm("Mark '" .. mark .. "' " .. buffer_name .. ':' .. line_number .. '  already exists.\nOverwrite?', '&yes\n&no', 2)
      if response ~= 1 then
        return
      end
    end
    -- Set the global mark
    vim.cmd('mark ' .. mark)
  end

  -- global marks
  local prefixes = "m'"
  local letters = 'abcdefghijklmnopqrstuvwxyz'
  for i = 1, #prefixes do
    local prefix = prefixes:sub(i, i)
    for j = 1, #letters do
      local lower_letter = letters:sub(j, j)
      local upper_letter = string.upper(lower_letter)
      if prefix == 'm' then
        M.general.vnx[prefix .. lower_letter] = {
          function()
            set_global_mark(upper_letter)
          end,
          ' Mark ' .. upper_letter,
        }
      else
        M.general.vnx[prefix .. lower_letter] = { prefix .. upper_letter, 'Go to mark ' .. upper_letter }
        -- M.general.vnx[prefix .. upper_letter] = { prefix .. lower_letter, 'Go to mark ' .. lower_letter }
      end
    end
  end
end

local _ = false and setup_marks_to_always_globals()

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

-- Reselect latest changed, put, or yanked text
map(
  'n',
  'gV',
  '"`[" . strpart(getregtype(), 0, 1) . "`]"',
  { expr = true, replace_keycodes = false, desc = 'Visually select changed text' }
)

-- Search inside visually highlighted text. Use `silent = false` for it to
-- make effect immediately.
map('x', 'g/', '<esc>/\\%V', { silent = false, desc = 'Search inside visual selection' })

-- Search visually selected text (slightly better than builtins in
-- Neovim>=0.8 but slightly worse than builtins in Neovim>=0.10)
-- TODO: Remove this after compatibility with Neovim=0.9 is dropped
if vim.fn.has 'nvim-0.10' == 0 then
  map('x', '*', [[y/\V<C-R>=escape(@", '/\')<CR><CR>]], { desc = 'Search forward' })
  map('x', '#', [[y?\V<C-R>=escape(@", '?\')<CR><CR>]], { desc = 'Search backward' })
end

-- map('c', { 'jk', 'kk', 'kj' }, back_to_cmdline_window, { noremap = true, silent = false, desc = '' })

-- Move only sideways in command mode. Using `silent = false` makes movements
-- to be immediately shown.
map('c', '<M-h>', '<Left>', { silent = false, desc = 'Left' })
map('c', '<M-l>', '<Right>', { silent = false, desc = 'Right' })

-- Window resize (respecting `v:count`)
map(
  'n',
  '<C-Left>',
  '"<Cmd>vertical resize -" . v:count1 . "<CR>"',
  { expr = true, replace_keycodes = false, desc = 'Decrease window width' }
)
map(
  'n',
  '<C-Down>',
  '"<Cmd>resize -"          . v:count1 . "<CR>"',
  { expr = true, replace_keycodes = false, desc = 'Decrease window height' }
)

map(
  'n',
  '<C-Up>',
  '"<Cmd>resize +"          . v:count1 . "<CR>"',
  { expr = true, replace_keycodes = false, desc = 'Increase window height' }
)
map(
  'n',
  '<C-Right>',
  '"<Cmd>vertical resize +" . v:count1 . "<CR>"',
  { expr = true, replace_keycodes = false, desc = 'Increase window width' }
)

local silent = false
local toggle_prefix = '<leader>T'
if type(toggle_prefix) == 'string' and toggle_prefix ~= '' then
  local map_toggle = function(lhs, rhs, desc)
    map('n', toggle_prefix .. lhs, rhs, { desc = desc })
  end

  --- - `b` - |'background'|.
  --- - `c` - |'cursorline'|.
  --- - `C` - |'cursorcolumn'|.
  --- - `d` - diagnostic (via |vim.diagnostic| functions).
  --- - `h` - |'hlsearch'| (or |v:hlsearch| to be precise).
  --- - `i` - |'ignorecase'|.
  --- - `l` - |'list'|.
  --- - `n` - |'number'|.
  --- - `r` - |'relativenumber'|.
  --- - `s` - |'spell'|.
  --- - `w` - |'wrap'|.
  if silent then
    map_toggle('b', '<Cmd>lua vim.o.bg = vim.o.bg == "dark" and "light" or "dark"<CR>', "Toggle 'background'")
    map_toggle('c', '<Cmd>setlocal cursorline!<CR>', "Toggle 'cursorline'")
    map_toggle('C', '<Cmd>setlocal cursorcolumn!<CR>', "Toggle 'cursorcolumn'")
    map_toggle('d', '<Cmd>lua MiniBasics.toggle_diagnostic()<CR>', 'Toggle diagnostic')
    map_toggle('h', '<Cmd>let v:hlsearch = 1 - v:hlsearch<CR>', 'Toggle search highlight')
    map_toggle('i', '<Cmd>setlocal ignorecase!<CR>', "Toggle 'ignorecase'")
    map_toggle('l', '<Cmd>setlocal list!<CR>', "Toggle 'list'")
    map_toggle('n', '<Cmd>setlocal number!<CR>', "Toggle 'number'")

    map_toggle('r', '<Cmd>setlocal relativenumber!<CR>', "Toggle 'relativenumber'")
    map_toggle('s', '<Cmd>setlocal spell!<CR>', "Toggle 'spell'")
    map_toggle('w', '<Cmd>setlocal wrap!<CR>', "Toggle 'wrap'")
  else
    map_toggle('b', '<Cmd>lua vim.o.bg = vim.o.bg == "dark" and "light" or "dark"; print(vim.o.bg)<CR>', "Toggle 'background'")
    map_toggle('c', '<Cmd>setlocal cursorline! cursorline?<CR>', "Toggle 'cursorline'")
    map_toggle('C', '<Cmd>setlocal cursorcolumn! cursorcolumn?<CR>', "Toggle 'cursorcolumn'")
    map_toggle('d', '<Cmd>lua print(MiniBasics.toggle_diagnostic())<CR>', 'Toggle diagnostic')
    map_toggle('h', '<Cmd>let v:hlsearch = 1 - v:hlsearch | echo (v:hlsearch ? "  " : "no") . "hlsearch"<CR>', 'Toggle search highlight')
    map_toggle('i', '<Cmd>setlocal ignorecase! ignorecase?<CR>', "Toggle 'ignorecase'")
    map_toggle('l', '<Cmd>setlocal list! list?<CR>', "Toggle 'list'")
    map_toggle('n', '<Cmd>setlocal number! number?<CR>', "Toggle 'number'")
    map_toggle('r', '<Cmd>setlocal relativenumber! relativenumber?<CR>', "Toggle 'relativenumber'")
    map_toggle('s', '<Cmd>setlocal spell! spell?<CR>', "Toggle 'spell'")
    map_toggle('w', '<Cmd>setlocal wrap! wrap?<CR>', "Toggle 'wrap'")
  end
end
-- Move by visible lines. Notes:
-- - Don't map in Operator-pending mode because it severely changes behavior:
--   like `dj` on non-wrapped line will not delete it.
-- - Condition on `v:count == 0` to allow easier use of relative line numbers.
map({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })

map({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

map('n', 'gO', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
map('n', 'go', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")

-- Copy/paste with system clipboard
map({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to system clipboard' })
map('n', 'gp', '"+p', { desc = 'Paste from system clipboard' })
-- - Paste in Visual with `P` to not copy selected text (`:h v_P`)
map('x', 'gp', '"+P', { desc = 'Paste from system clipboard' })

-- Reselect latest changed, put, or yanked text
map(
  'n',
  'gV',
  '"`[" . strpart(getregtype(), 0, 1) . "`]"',
  { expr = true, replace_keycodes = false, desc = 'Visually select changed text' }
)

-- Search visually selected text (slightly better than builtins in
-- Neovim>=0.8 but slightly worse than builtins in Neovim>=0.10)
-- TODO: Remove this after compatibility with Neovim=0.9 is dropped
if vim.fn.has 'nvim-0.10' == 0 then
  map('x', '*', [[y/\V<C-R>=escape(@", '/\')<CR><CR>]], { desc = 'Search forward' })
  map('x', '#', [[y?\V<C-R>=escape(@", '?\')<CR><CR>]], { desc = 'Search backward' })
end

-- Alternative way to save and exit in Normal mode.
-- NOTE: Adding `redraw` helps with `cmdheight=0` if buffer is not modified
-- map('n', '<C-S>', '<Cmd>silent! update | redraw<CR>', { desc = 'Save' })
map({ 'i', 'x' }, '<C-S>', '<Esc><Cmd>silent! update | redraw<CR>', { desc = 'Save and go to Normal mode' })

Positions = {}

local positions_used_ids = {}
local positions_current_index = 0

local function save_position()
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local id = tonumber(row)
  -- Check if the position already exists
  for i, pos in ipairs(Positions) do
    if pos.file == file and pos.line == row then
      -- Remove the position and clear the sign
      table.remove(Positions, i)
      -- Adjust the current index
      positions_current_index = positions_current_index - 1
      vim.fn.sign_unplace('PositionSigns', { id = id, buffer = file })
      print('Position removed: ' .. file .. ' [' .. row .. ', ' .. col .. ']')
      return
    end
  end
  -- Set sign in the buffer
  table.insert(Positions, { file = file, line = row, col = col })
  -- NOTE: instead of `file` we could use `buf`, which is a number
  -- But to ensure proper detection when using `sign_unplace`, we use the
  -- entire filename (it's in full path mode btw).
  vim.fn.sign_place(id, 'PositionSigns', 'PositionSign', file, { lnum = row, priority = 10 })
  print('Position saved: ' .. file .. ' [' .. row .. ', ' .. col .. ']')
end

function JumpPosition(count)
  if #Positions == 0 then
    print 'No positions saved'
    return
  end
  -- current_index = current_index % #positions + count
  positions_current_index = (positions_current_index + count - 1) % #Positions + 1
  local pos = Positions[positions_current_index]

  local win_found = false
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_name(buf) == pos.file then
      vim.api.nvim_set_current_win(win)
      vim.api.nvim_win_set_cursor(win, { pos.line, pos.col })
      win_found = true
      break
    end
  end

  -- Open the file if it's not already open in any window
  -- TODO Fix sign_unplace for .trails
  if not win_found then
    if vim.fn.filereadable(pos.file) == 0 then
      print('File not found: ' .. pos.file)
      table.remove(Positions, positions_current_index)
      vim.fn.sign_place(pos.row, 'PositionSigns', 'PositionSign', vim.api.nvim_get_current_buf(), { lnum = other.line, priority = 10 })
      return
    end

    vim.cmd('edit ' .. pos.file)
    for _, other in ipairs(Positions) do
      if other.file == pos.file then
        vim.fn.sign_place(pos.row, 'PositionSigns', 'PositionSign', vim.api.nvim_get_current_buf(), { lnum = other.line, priority = 10 })
      end
    end
    vim.api.nvim_win_set_cursor(0, { pos.line, pos.col })
  end

  print('Jumped to: ' .. pos.file .. ' [' .. pos.line .. ', ' .. pos.col .. ']')
end

-- Key mappings
map('n', '<leader>ms', save_position, { noremap = true, silent = true })

map('n', '<leader><tab>', ':b#<CR>', { noremap = true, silent = true })

local _ = false
  and map('n', '<leader><tab>', function()
    if LastBuffer then
      print('Last buffer ' .. vim.inspect(LastBuffer))
      vim.api.nvim_set_current_buf(LastBuffer)
    else
      print 'No last buffer to switch to.'
    end
  end, { noremap = true, silent = true })

SetKeyMaps(M.disabled)
SetKeyMaps(M.general)
SetKeyMaps(M.blankline)

vim.schedule(function()
  -- Disable fucking manual laggy search when theres windows directories on $PATH (wsl only)
  map('n', 'K', '<Nop>', { noremap = true, silent = true })
end)

map('n', '<F2>', function()
  --- See: https://github.com/ibhagwan/fzf-lua/wiki/Advanced
  local home = vim.env.HOME

  local files_from = function(dir)
    local list = {}
    local handle = vim.loop.fs_scandir(dir)
    while true do
      local name, _ = vim.loop.fs_scandir_next(handle)
      if not name then
        break
      end

      if not name:match '%/$' then
        table.insert(list, dir .. name)
      end
    end
    return list
  end
  require('fzf-lua').fzf_exec({
    home .. '/todo.md',
    'random',
    unpack(files_from(home .. '/docs/')),
  }, {
    prompt = 'Personal > ',
    actions = {
      -- Use fzf-lua builtin actions or your own handler
      ['default'] = require('fzf-lua').actions.file_edit,
      ['ctrl-y'] = function(selected, opts)
        Inspect { 'selected item:', selected[1], opts = opts }
      end,
    },
  })
end, { noremap = true, silent = true })
