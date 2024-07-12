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

-- Define a table to store previous positions

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

local function close_buffers_except_current_only_in_this_tab(right)
  -- local current_buf = vim.api.nvim_get_current_buf()
  -- local scope = require 'scope.utils'
  -- local buffers = scope.get_valid_buffers()

  local current_buf = vim.api.nvim_get_current_buf()
  local current_tab = vim.api.nvim_get_current_tabpage()
  require('scope.core').revalidate() -- Gotta fill the cache
  local buffers = require('scope.core').cache[current_tab]

  for i, buf in ipairs(buffers) do
    local check_for_difference = buf ~= current_buf
    local check_for_tabs_on_right = buf > current_buf
    local ok = (right and check_for_tabs_on_right) or (not right and check_for_difference)
    -- local ok = check_for_tabs_on_right

    if ok then
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
  -- local current_buffer = vim.api.nvim_get_current_buf()
  -- local current_path = vim.api.nvim_buf_get_name(current_buffer)
  -- if current_path and current_path ~= '' then
  --   table.insert(vim.g.user.buffer_paths, current_path)
  -- end
  vim.cmd 'Bdelete!'
end

local file_tree_reveal_toggle = function()
  local width = vim.o.columns
  local height = vim.o.lines
  local float_opts = {
    relative = 'editor',
    width = math.floor(width * 0.3),
    height = math.floor(height * 0.85),
    row = math.floor((height - math.floor(height * 0.6)) / 2),
    col = math.floor((width - math.floor(width * 0.6)) / 2),
    border = 'single',
  }

  local reveal_file = vim.fn.expand '%:p'

  if reveal_file == '' then
    reveal_file = vim.fn.getcwd()
  else
    local f = io.open(reveal_file, 'r')
    if f then
      f:close()
    else
      reveal_file = vim.fn.getcwd()
    end
  end

  if vim.g.self.file_tree == 'oil' then
  elseif vim.g.self.file_tree == 'neo-tree' then
    require('neo-tree.command').execute {
      action = 'focus', -- OPTIONAL, this is the default value
      source = 'filesystem', -- OPTIONAL, this is the default value
      position = 'float',
      toggle = true,
      reveal_file = reveal_file, -- path to file or folder to reveal
      reveal_force_cwd = false, -- change cwd without asking if needed
    }
  elseif vim.g.self.file_tree == 'nvim-tree' then
    require('nvim-tree.api').tree.toggle {
      find_file = true,
      -- find_file_update_cwd = true,
      -- update_focused_file = {
      --   enable = true,
      --   update_cwd = false,
      -- },
    }
    local tree_win_id = vim.fn.win_getid(vim.fn.win_getid(vim.fn.bufwinnr(vim.fn.bufname 'NvimTree')))
    if tree_win_id ~= -1 and require('nvim-tree.api').tree.is_visible() then
      -- Set the window to floating mode with centered position
      vim.api.nvim_win_set_config(tree_win_id, float_opts)
    end
  end
end

local file_tree_toggle = function(opts)
  -- opts.height_percentage, opts.width_percentage, opts.focus
  return function()
    local total_width = vim.o.columns
    local total_height = vim.o.lines
    local float_opts = {
      relative = 'editor',
      width = math.max(opts.width_min, math.floor(total_width * opts.width_percentage)),
      height = math.max(opts.height_min, math.floor(total_height * opts.height_percentage)),
      row = math.floor((total_height - math.floor(total_height * 0.65)) / 2),
      col = math.floor((total_width - math.floor(total_width * 0.6)) / 2),
      border = 'single',
    }

    if vim.g.self.file_tree == 'neo-tree' then
      require('neo-tree.command').execute {
        action = 'focus', -- OPTIONAL, this is the default value
        source = 'filesystem', -- OPTIONAL, this is the default value
        position = 'float',
        toggle = true,
        reveal_file = opts.focus, -- path to file or folder to reveal
        reveal_force_cwd = false, -- change cwd without asking if needed
      }
    elseif vim.g.self.file_tree == 'nvim-tree' then
      require('nvim-tree.api').tree.toggle {
        find_file = opts.focus,
      }
      local tree_win_id = vim.fn.win_getid(vim.fn.bufwinnr(vim.fn.bufname 'NvimTree'))

      if tree_win_id ~= -1 and require('nvim-tree.api').tree.is_visible() then
        -- Set the window to floating mode with centered position
        vim.api.nvim_win_set_config(tree_win_id, float_opts)
      end
    end
  end
end

local old_neotree_bufnr
function toggle_neo_tree()
  -- Get the window ID of the Neo-tree buffer
  local bufname = vim.fn.bufname 'neo-tree'
  local bufnr = vim.fn.bufnr(bufname)
  if old_neotree_bufnr ~= nil then
    print('about to show old_neotree_bufnr' .. old_neotree_bufnr)
    -- vim.cmd('sbuffer ' .. bufnr)
    return vim.api.nvim_open_win(bufnr, true, {})
  end
  local winnr = vim.fn.bufwinnr(bufname)
  local tree_winid = vim.fn.win_getid(winnr)

  print(' bufnr=' .. bufnr .. ' winnr=' .. winnr .. '\nbufname=' .. bufname .. '\ntree_winid=' .. tree_winid)
  if tree_winid ~= -1 and winnr ~= 1 then
    if old_neotree_bufnr == nil then
      old_neotree_bufnr = bufnr
    end
    vim.api.nvim_win_hide(tree_winid)
  end
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

-- Define a function to handle 'k' key behavior
local handle_k = function()
  local mode = vim.api.nvim_get_mode().mode
  if vim.v.count == 0 and mode ~= 'n' and mode ~= 'no' then
    return 'gk'
  else
    return 'k'
  end
end

-- Define a function to handle 'j' key behavior
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
    ['<Tab>'] = '',
    ['<S-Tab>'] = '',
  },
  n = {
    ['<C-a>'] = '',
    ['K'] = '', -- disable search for `man` pages, too slow
    ['<leader>D'] = '',
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
    ['d]'] = '',
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
  v = {
    -- comment
    ['<leader>/'] = '',
    ['<M-Down'] = '',
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
  vim.cmd 'copen'
  -- -- Close the quickfix window after setting the list
  -- vim.cmd "cclose"
end

local float_term = {
  terminal = nil,
  width_percentage = 0.63,
  height_percentage = 0.35,
  width_min = 70,
  height_min = 23,
}
local float_term_toggle = function()
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
    }
  f.terminal.float_opts.width = math.max(f.width_min, math.floor(vim.o.columns * f.width_percentage))
  f.terminal.float_opts.height = math.max(f.height_min, math.floor(vim.o.lines * f.height_percentage))
  f.terminal:toggle()
end

-- Function to jump to previous or next location within the current buffer
-- Function to get the current index in the jumplist
-- Initialize jumplist index
local current_jump_index = 0

local function get_jumplist()
  local jumplist = vim.fn.getjumplist()[1]
  -- return ReverseTable(jumplist)
  return jumplist
end

local function update_current_jump_index(offset)
  local jumplist = get_jumplist()

  local new_index = current_jump_index + offset
  -- If current position is not found in jumplist, adjust index based on direction
  if current_jump_index > #jumplist then
    new_index = #jumplist
  elseif current_jump_index < 1 then
    new_index = 1
  end

  current_jump_index = new_index
end

local jump_within_buffer = function(prev)
  local jumplist = get_jumplist()
  update_current_jump_index(prev and -1 or 1)

  local cmd = prev and '<c-o>' or '<c-i>'

  local starting = current_jump_index
  local ending = prev and 1 or #jumplist
  local step = prev and -1 or 1
  local curr_bufnr = vim.api.nvim_get_current_buf()
  local jump_count = 0
  for i = starting, ending, step do
    local jump = jumplist[i]
    jump_count = jump_count + 1
    if jump.bufnr == curr_bufnr then
      -- vim.fn.cursor(jumplist[i].lnum, jumplist[i].col)
      -- local win = vim.api.nvim_get_current_win()
      -- vim.api.nvim_win_set_cursor(win, { jump.lnum, jump.col })

      print(tostring(math.abs(current_jump_index - i)) .. cmd)
      vim.api.nvim_input(tostring(math.abs(current_jump_index - i)) .. cmd)

      current_jump_index = i
      -- Inspect {
      --   step = step,
      --   ending = ending,
      --   current_jump_index = current_jump_index,
      --   buf = jump.bufnr,
      --   count_jmplist = #jumplist,
      -- }
      return true
    end
  end
  return false
end

local function jump_to_prev_in_same_buffer()
  if jump_within_buffer(false) == false then
    print 'No previous jumps in the current buffer.'
  end
end

local function jump_to_next_in_same_buffer()
  if jump_within_buffer(true) == false then
    print 'No next jumps in the current buffer.'
  end
end

M.general = {
  -- [TERMINAL and NORMAL]
  tn = {},
  vnx = {
    ['<leader>rw'] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left><Space><BS><Down>]], '[R]eplace [W]ord' },
    ['<leader><leader>'] = { ':Norm <Down>', 'live preview of normal command' },
    [';'] = { ':<Down><Down>', 'Command Mode' },
    ['<C-\\>'] = {
      function()
        vim.api.nvim_input ':<Down><C-f>'
      end,
    },
    ['\\'] = {
      function()
        vim.api.nvim_input ':<Down>'
      end,
    },
  },

  -- [NORMAL]
  n = {
    ['<leader>hy'] = { ':YankHistory <cr>', '[H]istory [Y]ank' },
    ['<leader>5'] = { spelltoggle, '5 for [5]pell Toggle' },
    ['<leader>z'] = { '[s1z=``', 'Correct [Z]peling Mistakes' },

    ['<Esc>'] = { '<cmd>noh <CR>', 'Clear highlights' },

    -->> ToggleTerm
    ['<A-i>'] = {
      function()
        float_term_toggle()
        --vim.cmd [[startinsert]]
      end,
      'Totgle nvimtree',
    },
    ['<leader>rw'] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left><Space><BS>]], '[R]eplace [W]ord' },
    -->> neo-tree
    ['<leader>e'] = {
      file_tree_toggle { width_min = 70, height_min = 23, focus = false, width_percentage = 0.55, height_percentage = 0.65 },
      'Toggle neo tree',
    },
    ['<leader>E'] = { file_tree_toggle { width_min = 70, height_min = 23, focus = true, width_percentage = 0.55, height_percentage = 0.65 }, 'Toggle neo tree' },

    -->> NNN picker
    -- ['<leader>e'] = { '<cmd> NnnPicker <CR>', 'NNN Floating Window' },
    -- ['<leader>lr'] = {
    --   function()
    --     return ':IncRename ' .. vim.fn.expand '<cword>'
    --   end,
    --   { expr = true },
    -- },

    -->> commands
    ['<leader>gd'] = { grep_and_show_results, noremap_opts }, -- NOTE:This is remaped when lsp is present
    ['gf'] = { 'gFzz', noremap_opts },
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
          if last_terminal_mode == 'i' then
            vim.cmd 'startinsert'
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

    ['<leader>x'] = {
      function()
        close_buffers_except_current_only_in_this_tab(true)
      end,
      'close all buffers to the right of current one',
    },
    ['<leader>X'] = { close_buffers_except_current_only_in_this_tab, 'close all buffers expect current one' },

    -- save
    ['<C-s>'] = { '<cmd> w <CR>', 'Save file' },

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
    --["<leader>b"]      = { "<cmd> enew <CR>", "New buffer" },
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

    ['<S-l>'] = { ':bnext<CR>', noremap_opts },
    ['<S-h>'] = { ':bprevious<CR>', noremap_opts },

    -- Move text up and down
    ['<A-j>'] = { '<Esc>:m .+1<CR>==', noremap_opts },
    ['<A-k>'] = { '<Esc>:m .-2<CR>==', noremap_opts },

    -- >> move fast with crtl Movinge
    ['<C-h>'] = { 'b', noremap_opts },
    ['<C-l>'] = { 'e', noremap_opts },

    ['<C-Left>'] = { 'b', noremap_opts },
    ['<C-Right>'] = { 'e', noremap_opts },

    ['<C-j>'] = { '}', noremap_opts },
    ['<C-k>'] = { '{', noremap_opts },

    ['<leader>w'] = { ':w<CR>', noremap_opts },
    ['<leader>q'] = { ':q<CR>', noremap_opts },
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

    ['[d'] = { vim.diagnostic.goto_prev, noremap_opts },
    [']d'] = { vim.diagnostic.goto_next, noremap_opts },
    ['U'] = { '<C-r>' },
    --['<leader>re']     ={  'yW:%s/<C-r>*/<C-r>*/gc<Left><Left><Left><Down>',  noremap_opts},
    ['<leader>re'] = { ':%s///g<Left><Left><Left><Down>', noremap_opts },

    ['<leader>d'] = { '"_d', noremap_opts },
    ['<leader>D'] = { '"_D', noremap_opts },
    --["<leader>p"]      = { '"_p',  noremap_opts },
    ['x'] = { '"_x', noremap_opts },
    -- ['s'] = { '"_s', noremap_opts }, -- Were using surround so this key must go
    ['ge'] = { 'G', noremap_opts },
    ['gh'] = { 'v:count || mode(1)[0:1] == "no" ? "0" : "g0"', 'Move big left', { expr = true } },
    ['gl'] = { 'v:count || mode(1)[0:1] == "no" ? "$" : "g$"', 'Move big right', { expr = true } },
  },

  i = {
    -- go to  beginning and end
    ['<C-b>'] = { '<ESC>^i', 'Beginning of line' },
    ['<C-e>'] = { '<End>', 'End of line' },

    -- navigate within insert mode
    ['<C-h>'] = { '<Left>', 'Move left' },
    ['<C-l>'] = { '<Right>', 'Move right' },
    ['<C-j>'] = { '<Down>', 'Move down' },
    ['<C-k>'] = { '<Up>', 'Move up' },
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
    -- ['<C-c>'] = { '<Esc>', noremap_opts },
    ['<M-U>'] = { '<C-o><C-r>' },
  },
  -- Visual --
  v = {
    ['<leader>n'] = { ':norm ', 'normal keys insertion', { expr = true } },
    ['<Up>'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', { expr = true } },
    ['<Down>'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', { expr = true } },
    ['gh'] = { 'v:count || mode(1)[0:1] == "no" ? "0" : "g0"', 'Move big left', { expr = true } },
    ['gl'] = { 'v:count || mode(1)[0:1] == "no" ? "$" : "g$"', 'Move big right', { expr = true } },
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

    ['p'] = { '"_dP', noremap_opts },

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

    ['<leader>re'] = { ':s///g<Left><Left><Left><Down><Down>', noremap_opts },

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
    ['c'] = { '"_c', noremap_opts },
    ['ge'] = { 'G', noremap_opts },
    ['<leader>s'] = { '"_s', noremap_opts },

    ['<leader>p'] = { '"+p', noremap_opts },
    ['<leader>P'] = { '"+P', noremap_opts },
  },
  x = {
    ['<Up>'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', { expr = true } },
    ['<Down>'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', { expr = true } },
    ['gh'] = { 'v:count || mode(1)[0:1] == "no" ? "0" : "g0"', 'Move big left', { expr = true } },
    ['gl'] = { 'v:count || mode(1)[0:1] == "no" ? "$" : "g$"', 'Move big right', { expr = true } },
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
    ['<C-w>'] = { vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true, true), 'Escape terminal mode' },
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
    ['<leader>b'] = { '<cmd> Telescope buffers initial_mode=normal<CR><esc>', 'Find buffers' },
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

M.blankline = {
  n = {
    ['<leader>jc'] = {
      function()
        local bufnr = vim.api.nvim_get_current_buf()
        local config = require('ibl.config').get_config(bufnr)
        local scope = require('ibl.scope').get(bufnr, config)
        if scope then
          local row, column = scope:start()
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { row + 1, column })
          vim.cmd [[normal! _]]
        end
      end,

      'Jump to current context',
    },
  },
}

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
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

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

local function set_global_mark(mark)
  local existing_mark = vim.fn.getpos("'" .. mark)
  -- Check if the mark is already set (line number will be > 0)
  if existing_mark[2] > 0 then
    local buffer_name = vim.fn.bufname(existing_mark[1])
    local line_number = existing_mark[2]
    -- Prompt the user for confirmation
    local response = vim.fn.confirm("Mark '" .. mark .. "' " .. buffer_name .. ':' .. line_number .. '  already exists.\nOverwrite?', '&yes\n&no', 2)
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
    end
  end
end
SetKeyMaps(M.disabled)
SetKeyMaps(M.general)
SetKeyMaps(M.blankline)
