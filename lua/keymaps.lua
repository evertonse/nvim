--
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
--  See :map <leader> to show all keymappings starting with the leader key
--
--

local term_opts = { silent = true }
local noremap_opts = { noremap = true, silent = true }
local nowait_opts = { noremap = true, silent = true, nowait = true }
FULLSCREEN = false

local M = {}
-- add this table only when you want to disable default keys
-- TIPS `:map <key>` to see all keys with that prefix

-- redirect output of command to scratch buffer

local current_buffer_file_extension = function()
  local extension = vim.fn.expand '%:e'
  return extension
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
    ['<leader>D'] = '',
    ['<S-tab>'] = '',
    ['<tab>'] = '',
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
  local _, tt = pcall(require, 'toggleterm.terminal')
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

M.general = {
  -- [TERMINAL and NORMAL]
  tn = {},
  -- [NORMAL]
  n = {

    -->> ToggleTerm
    ['<A-i>'] = {
      function()
        float_term_toggle()
        --vim.cmd [[startinsert]]
      end,
      'Toggle nvimtree',
    },
    ['<leader>rw'] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], '[R]eplace [W]ord' },
    -->> neo-tree
    -- ['<leader>e'] = { '<cmd> Neotree toggle <CR>', 'Toggle neo tree' },
    ['<leader>E'] = { '<cmd> Neotree reveal <CR>', 'Toggle neo tree' },
    ['<leader>e'] = { '<cmd> NnnPicker <CR>', 'NNN Floating Window' },
    -->> commands
    ['<leader>gd'] = { grep_and_show_results, noremap_opts },
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
    ['<C-w>z'] = {
      function()
        vim.cmd 'split v'
      end,
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
    ['<leader>hb'] = {
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
    ['Q'] = { '@', 'Activate MACRO on q register' },
    -- ["q"]             = { "q", "Activate MACRO on q register" },
    -- ["Q"]             = { ToggleRecording, "Record MACRO on q register" },
    --
    -- ["Q"]             = { "qq", "Record MACRO on q register" },

    ['<leader>x'] = { ':%bd!|e# <cr>', 'close all buffers expect current one' },
    ['<Esc><Esc>'] = { ':noh <CR>', 'Clear highlights' },

    -- save
    ['<C-s>'] = { '<cmd> w <CR>', 'Save file' },

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
    ['j'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', { expr = true } },
    ['k'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', { expr = true } },
    ['<Up>'] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', 'Move up', { expr = true } },
    ['<Down>'] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', 'Move down', { expr = true } },

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
    ['<leader>c'] = { ':Bdelete!<CR>', noremap_opts },
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
    ['s'] = { '"_s', noremap_opts },
    ['ge'] = { 'G', noremap_opts },
    ['gh'] = { 'v:count || mode(1)[0:1] == "no" ? "0" : "g0"', 'Move big left', { expr = true } },
    ['gl'] = { 'v:count || mode(1)[0:1] == "no" ? "$" : "g$"', 'Move big right', { expr = true } },
  },

  i = {
    -- go to  beginning and end
    ['<tab>'] = { '<space><space><space><space>', '4 spaces' },
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
    ['<C-c>'] = { '<Esc>', noremap_opts },
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
    ['s'] = { '"_s', noremap_opts },
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
    ['s'] = { '"_s', noremap_opts },
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
  plugin = true,

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
  plugin = true,

  n = {
    ['<leader>jc'] = {
      function()
        local ok, start =
          require('indent_blankline.utils').get_current_context(vim.g.indent_blankline_context_patterns, vim.g.indent_blankline_use_treesitter_scope)

        if ok then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
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

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

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
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Function to set keymaps
local function set_keymaps(mode, key, mapping)
  local opts = nowait_opts
  if type(mapping[2]) == 'table' then
    opts = vim.tbl_deep_extend('force', mapping[2], opts)
  elseif type(mapping[2]) == 'string' then
    opts = vim.tbl_deep_extend('force', mapping[3] or {}, opts)
    opts.desc = mapping[2]
  else
    opts = { noremap = true, silent = true }
  end
  vim.keymap.set(mode, key, mapping[1], opts)
end

-- Delete maps do disable
for mode, mappings in pairs(M.disabled) do
  for key, _ in pairs(mappings) do
    pcall(function()
      vim.keymap.del(mode, key)
    end)
  end
end

for modes, mappings in pairs(M.general) do
  for mode in modes:gmatch '.' do
    for key, mapping in pairs(mappings) do
      set_keymaps(mode, key, mapping)
    end
  end
end
-- vim: ts=2 sts=2 sw=2 et
