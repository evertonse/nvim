local previous_stats = {
  mode = 'n',
  laststatus = vim.opt.laststatus,
  number = vim.wo.number,
  relativenumber = vim.wo.relativenumber,
  cmdheight = vim.opt.cmdheight,
  ministatusline_disable = vim.g.ministatusline_disable,
}

local augroup = function(name)
  return vim.api.nvim_create_augroup('my_nvim_' .. name, { clear = true })
end

local function is_in_cmdline()
  return vim.fn.getcmdwintype() ~= '' or vim.fn.mode():match '^[/:]' ~= nil
end

local excyber = vim.api.nvim_create_augroup('1', { clear = true })
local au = function(event, pattern, callback, desc, augroup, once)
  vim.api.nvim_create_autocmd(
    event,
    { group = augroup or excyber, once = once or false, pattern = pattern, callback = callback, desc = desc }
  )
end

-- Apperantly " in front of a line in vimscript is a comment?
vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
    autocmd WinLeave * setlocal nocursorline
    autocmd FileType qf,nofile,help set nobuflisted
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end


  augroup _tex
    autocmd!
    autocmd FileType tex setlocal wrap
  augroup end

  function! Odin_settings()
    setlocal tabstop=4
    setlocal shiftwidth=4
  endfunction
  autocmd FileType odin call Odin_settings()

  "autocmd FileType python :setlocal tabstop=4 shiftwidth=4 expandtab
  "autocmd FileType lua :setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd FileType cpp :setlocal tabstop=4 shiftwidth=4 expandtab

  autocmd FileType Telescope* setlocal nocursorline



  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd=
    " autocmd VimResized * lua print("VimResized")
    " autocmd WinResized * lua print("WinResized")
  augroup end


   " Return to last edit position when opening files (You want this!)
  autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

]]

vim.cmd [[ autocmd FileType *.c nnoremap <buffer> <F5> :w<CR>:term gcc % -o %:r && ./%:r<CR> ]]
-- vim.cmd [[autocmd filetype cpp nnoremap <F5> :!g++ % -ggdb -o %:r && ./%:r <CR>]]
-- vim.cmd [[autocmd FileType c nnoremap <F5> :!gcc % -g -o %:r && ./%:r <CR>]]

-- vim.cmd [[autocmd FileType * nnoremap <F5> :!make run <CR>]]
vim.cmd [[
augroup Binary
  au!
  au BufReadPost *.xxd set ft=xxd | endif
  au BufReadPost *.bin set ft=bin | endif
  au BufReadPost *.exe set ft=bin | endif
augroup END
]]

vim.cmd [[autocmd FileType bin,exe nnoremap <F5> :%!xxd <CR>]]
vim.cmd [[autocmd FileType bin,exe nnoremap <F6> :%!xxd -r <CR>]]

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { pattern = { '*.txt', '*.md', '*.tex' }, command = 'setlocal spell' })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { pattern = { '*.txt', '*.md', '*.tex' }, command = 'setlocal wrap' })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { pattern = { '*.tex' }, command = 'setlocal ft=tex' })

-- vim.cmd [[autocmd filetype python nnoremap <F5> :w <bar> exec '!python '.shellescape('%')<CR>]]
-- vim.cmd [[autocmd filetype c nnoremap <F5> :w <bar> exec '!gcc '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>]]
-- vim.cmd [[autocmd filetype cpp nnoremap <F5> :w <bar> exec '!g++ '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>]]
vim.cmd [[autocmd TermEnter,TermOpen * setlocal nonumber norelativenumber signcolumn=no]]
-- vim.cmd [[autocmd TermOpen * startinsert ]] -- stopinsert ]]        -- starts terminal in insert mode

-- Auto command to activate virtual environment on terminal open
-- vim.cmd([[
--     augroup AutoActivateVirtualEnv
--         autocmd!
--           autocmd TermOpen * :lua if vim.fn.isdirectory( vim.fn.getcwd() .. '/venv' ) then print('source ./venv/bin/activate') else print ('nothing') end
--     augroup end
-- ]])

-- vim.cmd [[
-- " WSL yank support
--     let s:clip = '/mnt/c/Windows/System32/clip.exe' " change this path according to your mount point
--
--     if executable(s:clip)
--
--     augroup WSLYank
--
--     autocmd!
--
--     autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, u/0
--
--     ) | endif
--
--     augroup END
--
--     endif
-- ]]
--
-- Create a function to check and delete buffers
local function clean_up_buffers()
  assert(0)
  local buffers = vim.api.nvim_list_bufs()

  for _, buf in ipairs(buffers) do
    -- Check if the buffer is valid and listed
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'buflisted') then
      -- Check if the buffer is unnamed or hidden
      local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
      local bufname = vim.api.nvim_buf_get_name(buf)
      if buftype == 'nofile' or bufname == '' or bufname == '[No Name]' then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end
end

local yank_history = {}
local function get_yank_file_path()
  -- Get the current working directory
  local cwd = vim.fn.getcwd()
  -- Define the file path for storing the last yank
  return cwd .. '/.last_yank.txt'
end

local function save_last_yank()
  local yank_file = get_yank_file_path()
  local file = io.open(yank_file, 'w')
  if file then
    for _, text in ipairs(yank_history) do
      if text ~= '' then
        file:write(text .. '\n')
      end
    end
    file:close()
  end
end

local MAX_LINES_TO_LOAD = 25

local function load_last_yank()
  local yank_file = get_yank_file_path()
  local file = io.open(yank_file, 'r')
  if file then
    yank_history = {}
    local last_line = nil
    local idx = 0
    for line in file:lines() do
      idx = idx + 1

      if line ~= '' then
        table.insert(yank_history, line)
        last_line = line
      end

      if idx >= MAX_LINES_TO_LOAD then
        break
      end
    end
    if last_line and last_line ~= '' then
      vim.fn.setreg('"', last_line)
    end
    file:close()
  end
  yank_history = { unpack(yank_history, math.max(1, #yank_history - MAX_LINES_TO_LOAD), #yank_history) }
end

local function save_positions_to_file(file_path)
  local file = io.open(file_path, 'w')
  if file then
    for _, pos in ipairs(Positions) do
      file:write(pos.file .. ':' .. pos.line .. ':' .. pos.col .. '\n')
    end
    file:close()
    print('Positions saved to ' .. file_path)
  else
    Inspect('Error: Could not open file ' .. file_path)
  end
end

local place_signs = function()
  vim.schedule(function()
    for _, pos in ipairs(Positions) do
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf) == pos.file then
          vim.fn.sign_place(pos.line, 'PositionSigns', 'PositionSign', buf, { lnum = pos.line, priority = 10 })
        end
      end
    end
  end)
end

local function load_positions_from_file(file_path)
  -- Create sign group and sign
  vim.fn.sign_define('PositionSign', { text = ' ', texthl = 'DiffAdd', linehl = '', numhl = '' })
  local pfile = io.open(file_path, 'r')
  if pfile then
    Positions = {}
    for pline in pfile:lines() do
      local file, line, col = pline:match '^(.*):(%d+):(%d+)$'
      if file and line and col then
        table.insert(Positions, { file = file, line = tonumber(line), col = tonumber(col) })
      end
    end
    pfile:close()

    -- These placing and loading signs doesn't work their not  in sync with anything
    if false then
      --- Printing gets annoying
      print('Positions loaded from ' .. file_path)
      place_signs()
    end
  else
    print('Error: Could not open file ' .. file_path)
  end
end

-- Autocommand to save the last yanked text before exiting Neovim
au('VimLeavePre', nil, function()
  save_last_yank()
  local path = vim.fn.getcwd() .. '/.trails'
  save_positions_to_file(path)
end, 'Close buffers, Load Yank, and stuff', excyber)

au('VimEnter', '*', function()
  clean_up_buffers()
  load_last_yank()
  local path = vim.fn.getcwd() .. '/.trails'

  vim.keymap.set('n', '<A-n>', function()
    JumpPosition(1)
  end, { noremap = true, silent = true })

  vim.keymap.set('n', '<A-p>', function()
    JumpPosition(-1)
  end, { noremap = true, silent = true })

  load_positions_from_file(path)
end, 'Close buffers, Load Yank, and stuff', excyber)

-- close quicklist after enter

local function capture_yank()
  local yanked_text = vim.fn.getreg '"'
  table.insert(yank_history, yanked_text)
end

OpenFloatingWindow = function(opts)
  opts = opts or {}
  local width = opts.width or 80
  local height = opts.height or 10
  local title = opts.title or 'Floating Window'
  local buflines = opts.lines or nil
  local buf = opts.buf or vim.api.nvim_create_buf(false, true)
  Inspect(opts)

  -- Set the lines in the buffer
  if buflines ~= nil then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, buflines)
  end

  -- Calculate the dimensions for the floating window
  local win_width = vim.api.nvim_get_option 'columns'
  local win_height = vim.api.nvim_get_option 'lines'
  local col = math.floor((win_width - width) / 2)
  local row = math.floor((win_height - height) / 2)

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'single',
    title = title,
    title_pos = 'center',
  })

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')

  -- Set window options
  vim.api.nvim_win_set_option(win, 'wrap', false)
  vim.api.nvim_win_set_option(win, 'cursorline', true)

  -- Return both the buffer and window handles
  return buf, win
end

-- Function to handle line selection
local function handle_line_selection(callback)
  local line = vim.fn.getline '.'
  if callback then
    callback(line)
  end
end

-- Call the example usage
-- local buf, win = example_usage()
local function open_floating_window_for_position()
  local select_trail = function(win)
    local line = vim.fn.getline '.'
    local file, line, col = line:match '^(.*):(%d+):(%d+)$'
    if file and line and col then
      vim.api.nvim_win_close(win, true) -- Close the floating window
      vim.cmd('edit ' .. file)
      vim.fn.cursor(tonumber(line), tonumber(col))
    end
  end

  local buf = vim.api.nvim_create_buf(false, true) -- Create a new buffer
  local lines = {}
  for _, pos in ipairs(Positions) do
    table.insert(lines, pos.file .. ':' .. pos.line .. ':' .. pos.col)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines) -- Set the trails as lines in the buffer

  -- Calculate the dimensions for the floating window
  local width = 80
  local height = 10
  local win_width = vim.api.nvim_get_option 'columns'
  local win_height = vim.api.nvim_get_option 'lines'
  local col = math.floor((win_width - width) / 2)
  local row = math.floor((win_height - height) / 2)

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'single',
  })

  -- Remap Enter key to go to the trail on the selected line and close the window
  vim.keymap.set(
    'n',
    '<CR>',
    -- [[<cmd>lua select_trail(]] .. buf .. [[, ]] .. win .. [[)<CR>]],
    function()
      select_trail(win)
    end,
    { buffer = buf, noremap = true, silent = true }
  )
end

vim.keymap.set('n', '<leader>Tm', open_floating_window_for_position, { noremap = true, silent = true })

TextPostDontTrigger = false

local _ = true
  and vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = excyber,
    callback = function()
      vim.highlight.on_yank { higroup = 'Visual', timeout = 210 }
      capture_yank()
      if previous_stats.mode ~= 'n' and previous_stats.mode ~= 'no' then
        local _ = false and Inspect { previous_stats.mode, previous_stats.mode ~= 'no', previous_stats.mode ~= 'n' }
        vim.schedule(function()
          -- HACK: workaround, doest work on the yank and stop where you where feat. on floating windows
          local is_floating = vim.api.nvim_win_get_config(0).relative ~= ''
          if vim.v.operator == 'y' and not TextPostDontTrigger and not is_floating and not is_in_cmdline() then
            vim.schedule(function()
              vim.api.nvim_input '<esc>gv<esc>'
            end)
          end
        end)
      end
    end,
  })

-- TODO: Make it come back to the line it once was, probably have to
-- delete lê
local function focus_window(event)
  local win_id = vim.api.nvim_get_current_win()
  local is_floating = vim.api.nvim_win_get_config(win_id).relative ~= ''
  local is_cmdline_window = is_in_cmdline()
  local current_buf = vim.api.nvim_get_current_buf()

  -- local is_cmdline_window = win_config.relative == 'editor' and vim.fn.getcmdwintype() ~= ''
  local current_filetype = vim.api.nvim_buf_get_option(current_buf, 'filetype')
  local is_terminal = vim.api.nvim_buf_get_option(current_buf, 'buftype') == 'terminal'

  if is_terminal or is_cmdline_window or is_floating or current_filetype == 'qf' then
    return
  end

  local editor_width = vim.o.columns
  local editor_height = vim.o.lines

  -- Define the desired width and height percentages
  local width_percentage = 0.57
  local height_percentage = 0.65

  -- Calculate new dimensions
  local new_width = math.floor(editor_width * width_percentage)
  local new_height = math.floor(editor_height * height_percentage)

  -- Resize the current window

  vim.api.nvim_win_set_width(win_id, new_width)
  vim.cmd [[wincmd =]]
  local current_height = vim.api.nvim_win_get_height(win_id)

  -- Resize the current window height only if the new height is greater than the current height
  if new_height > current_height then
    vim.api.nvim_win_set_height(win_id, new_height)
  end
  -- vim.wowin_id].signcolumn = 'yes'
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if true or w ~= win_id and vim.api.nvim_win_get_config(w).relative ~= '' then
      local win_config = vim.api.nvim_win_get_config(w)
      local w_filetype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(w), 'filetype')
      local w_terminal = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(w), 'buftype') == 'terminal'
      if not (w_terminal or win_config.relative ~= '' or w_filetype == 'qf') then
        vim.wo[w].signcolumn = 'no'
        vim.wo[w].number = false
        vim.wo[w].relativenumber = false
      end
      -- vim.cmd [[setlocal nonumber norelativenumber signcolumn=no]]
    end
  end

  if not is_terminal then
    vim.wo[win_id].signcolumn = vim.g.self.signcolumn
    vim.wo[win_id].number = true
    vim.wo[win_id].relativenumber = true
  end
end

au({ 'WinEnter', 'BufWinEnter', 'WinNew' }, '*', function(event)
  vim.schedule(function()
    focus_window(event)
  end)
end)

local _ = false and au({ 'WinEnter' }, '*', function(_) end)

LastBuffer = nil
au('BufLeave', '*', function(event)
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_buffer_name = vim.api.nvim_buf_get_name(current_buffer)

  -- Check if the current buffer is loaded and has a valid name
  if vim.api.nvim_buf_is_loaded(current_buffer) and current_buffer_name ~= '' then
    if LastBuffer ~= current_buffer then
      LastBuffer = current_buffer
    end
  end
end)

local telescope_yank_history = function()
  local finders = require 'telescope.finders'
  local pickers = require 'telescope.pickers'
  local actions = require 'telescope.actions'
  local sorters = require 'telescope.sorters'
  local action_state = require 'telescope.actions.state'
  local opts = require('telescope.themes').get_dropdown { sorting_strategy = 'descending' }

  local reverse_sorter = sorters.new {
    scoring_function = function(_, prompt, entry)
      return -2
    end,
  }
  -- ShowStringAndWait(vim.inspect(opts))
  -- opts.sorting_strategy = 'ascending'
  pickers
    .new({}, {
      prompt_title = 'Yank History',
      finder = finders.new_table {
        -- results = reverse_table(yank_history),
        results = yank_history,
        entry_maker = function(entry)
          if not entry then
            return {}
          end
          local width = vim.api.nvim_win_get_width(0) - 4 -- Adjust as needed
          local newline_index = math.max(string.find(entry, '\n', 1, true) - 1, 0)
          -- Clamp to the nearest newline if found, or clamp to the specified width
          local clamped_output = newline_index and string.sub(entry, 1, newline_index) or string.sub(entry, 1, width)
          return {
            display = clamped_output,
            value = entry,
            ordinal = entry,
          }
        end,
      },

      sorter = reverse_sorter,
      -- sorter = sorters.highlighter_only(opts),
      attach_mappings = function(_, map)
        local choose = function(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.fn.setreg('"', selection.value)
          actions.close(prompt_bufnr)
        end
        map({ 'n', 'i' }, '<CR>', choose)
        map({ 'n', 'i' }, 'y', choose)
        map({ 'n', 'i' }, 'l', choose)
        return true
      end,
    })
    :find()
end

local enable_lsp_highlighting = true
local function toggle_lsp_comments()
  local DeadCode = '#878787'
  if enable_lsp_highlighting then
    vim.api.nvim_set_hl(0, '@lsp.type.comment.c', {})
    vim.api.nvim_set_hl(0, '@lsp.type.comment.cpp', {})
  else
    vim.api.nvim_set_hl(0, '@lsp.type.comment.c', { fg = DeadCode })
    vim.api.nvim_set_hl(0, '@lsp.type.comment.cpp', { fg = DeadCode })
  end
  enable_lsp_highlighting = not enable_lsp_highlighting
end

vim.api.nvim_create_user_command('LspToggleComments', toggle_lsp_comments, {})
-- Custom sorter that sorts in reverse order
vim.api.nvim_create_user_command('TelescopeYankHistory', telescope_yank_history, {})

-- -- Function to move the cursor to line 1 in the quickfix window
-- local function set_quickfix_cursor_to_line_1()
--   -- Check if the current buffer is a quickfix list
--   if vim.bo.buftype == 'quickfix' then
--     -- Move the cursor to line 1
--
--     vim.cmd 'normal! gg'
--   end
-- end
--
-- -- Create an autocommand group for quickfix commands
-- vim.api.nvim_create_augroup('QuickfixCursor', { clear = true })
--
-- -- Add an autocommand to set the cursor to line 1 after opening a quickfix list
-- vim.api.nvim_create_autocmd('QuickFixCmdPre', {
--   group = 'QuickfixCursor',
--   pattern = '*',
--   callback = set_quickfix_cursor_to_line_1,
-- })
--
-- Function to show yank history in a custom quickfix window
local function show_yank_history_on_quick()
  local qf_list = {}

  for idx = #yank_history, 1, -1 do
    local entry = yank_history[idx]
    table.insert(qf_list, {
      -- filename = entry,
      -- pattern = entry,
      module = entry:gsub('\n', '\\n'):match '^%s*(.-)%s*$',
      -- lnum = idx,
      -- col = 0,
      -- nr = idx,
      -- text = entry,
      user_data = entry,
    })
  end

  vim.fn.setqflist(qf_list)
  vim.cmd 'horizontal copen'
  vim.cmd 'resize 8' -- Optional: Set the height of the quickfix window
  vim.cmd 'normal! gg'

  local get_selected_location_entry = function()
    local qfl = vim.fn.getqflist()
    local lnum, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local idx = lnum

    if not vim.api.nvim__buf_stats(0).current_lnum == lnum then
      print 'WARNING: lnum changed'
      lnum = vim.api.nvim__buf_stats(0).current_lnum
    end

    -- Inspect { lnum, qfl[idx].user_data, qfl = qfl }
    if idx > 0 and idx <= #qfl then
      return qfl[idx]
    else
      print "Couldn't yank from history"
      return ''
    end
  end

  local choose = function()
    local data = get_selected_location_entry().user_data
    -- Inspect { data }
    vim.fn.setreg('"', data)
    vim.cmd 'cclose'
  end
  -- Define the quickfix command mappings
  local mappings = {
    ['<CR>'] = choose,
    ['y'] = choose,
    ['<c-y>'] = choose,
    ['l'] = choose,
  }

  -- Set the mappings for the quickfix window
  for key, func in pairs(mappings) do
    vim.keymap.set('n', key, func, {
      buffer = 0,
      silent = true,
      noremap = true,
      expr = false,
      nowait = true,
    })
  end
end

-- Initialize a stack to keep track of directories
local dir_stack = {}

-- Function to push the current directory onto the stack

local function push_dir()
  table.insert(dir_stack, vim.fn.getcwd())
end

-- Function to pop the last directory from the stack
local function pop_dir()
  if #dir_stack > 0 then
    local last_dir = table.remove(dir_stack)
    vim.cmd('cd ' .. last_dir)
  else
    print 'Directory stack is empty.'
  end
end

local function open_floating_window_for_directories()
  local select_directory = function(win, index)
    local dir = dir_stack[index]

    if dir then
      table.remove(dir_stack, index) -- Remove the selected directory from the stack
      vim.api.nvim_win_close(win, true) -- Close the floating window
      vim.cmd('cd ' .. dir) -- Change to the selected directory
    end
  end

  local buf = vim.api.nvim_create_buf(false, true) -- Create a new buffer
  local lines = {}
  for i, dir in ipairs(dir_stack) do
    table.insert(lines, dir) -- Add each directory to the lines
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines) -- Set the directories as lines in the buffer

  -- Calculate the dimensions for the floating window
  local width = 80

  local height = 10
  local win_width = vim.api.nvim_get_option 'columns'
  local win_height = vim.api.nvim_get_option 'lines'
  local col = math.floor((win_width - width) / 2)
  local row = math.floor((win_height - height) / 2)

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',

    border = 'single',
  })

  -- Remap 'o' key to go to the selected directory and close the window
  vim.keymap.set('n', 'o', function()
    local cursor_line = vim.fn.line '.' -- Get the current line in the buffer
    select_directory(win, cursor_line) -- Pass the line number to select_directory
  end, { buffer = buf, noremap = true, silent = true })

  vim.keymap.set('n', 'q', '<cmd>q<cr>', { buffer = buf, noremap = true, silent = true })

  vim.keymap.set('n', '<cr>', function()
    local cursor_line = vim.fn.line '.' -- Get the current line in the buffer
    select_directory(win, cursor_line) -- Pass the line number to select_directory
  end, { buffer = buf, noremap = true, silent = true })
end

-- Example usage: Add directories to the stack
table.insert(dir_stack, '/tmp')
table.insert(dir_stack, '~/code')

-- Autocommand to push the directory onto the stack when changing directories
vim.api.nvim_create_augroup('ChangeDir', { clear = true })
vim.api.nvim_create_autocmd('DirChangedPre', {
  group = 'ChangeDir',
  callback = push_dir,
})

vim.api.nvim_create_user_command('CdHistory', open_floating_window_for_directories, {})
vim.api.nvim_create_user_command('CdPop', pop_dir, {})
vim.api.nvim_create_user_command('YankHistory', show_yank_history_on_quick, {})

vim.api.nvim_create_user_command('ClearEmptyLines', function()
  vim.cmd [[%s/^\s*$//g]] -- begining empty lines and
  vim.cmd [[%s/\s*$//g]]
  vim.cmd [[nohlsearch]]
  vim.api.nvim_input [[<c-o>]]
  vim.cmd [[]]
end, {})

-- Autocmd to apply the mapping when entering the quickfix window
au('Filetype', 'qf', function(event)
  vim.cmd [[setlocal nowrap]]
  vim.cmd [[setlocal norelativenumber]]

  -- vim.api.nvim_buf_set_keymap(0, 'n', 'l', '<CR>', { noremap = true, silent = true })

  -- Set the mappings for the quickfix window
  local mappings = {
    -- ['<CR>'] = function()
    --   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'i', false)
    --   vim
    --   vim.cmd 'cclose'
    -- end,
    ['<cr>'] = '<cr><cmd>cclose<CR>',
    ['l'] = '<cr><cmd>cclose<CR>',
    ['<Esc>'] = ':cclose<CR>',
    ['q'] = ':cclose<CR>',
  }
  for key, func in pairs(mappings) do
    vim.keymap.set('n', key, func, {
      buffer = 0,
      silent = true,
      noremap = true,
      expr = false,
      nowait = true,
    })
  end
end)

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    -- HACK: solving with always setting this on buf enter or filetype, might be sorta slow
    -- instead of just setting it once. This is because the runtime ftplugin is setting formatoption :P lovely
    -- vim.cmd [[set formatoptions=qrn1j]]
    -- :h ftplugin-overrule

    -- vim.b.did_ftplugin = 1
    local preserve_previous = true

    if not preserve_previous then
      vim.opt.formatoptions = 'qjl1' -- Don't autoformat comments
      return
    end

    vim.opt.formatoptions:remove { 'c', 'r', 'o', 'l' } -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
  end,
})

-- Create an autocommand group for our buffer delete event
local function save_buffer_path(args)
  local bufnr = args.buf
  local buffer_path = vim.api.nvim_buf_get_name(bufnr)
  if buffer_path and buffer_path ~= '' then
    table.insert(BufferPaths, buffer_path)
  end
end

-- Create an autocommand to save buffer path on buffer delete
vim.api.nvim_create_autocmd('BufDelete', {
  group = vim.api.nvim_create_augroup('SaveBufferPathOnDelete', { clear = true }),
  callback = save_buffer_path,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'odin' },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.api.nvim_create_autocmd('CompleteDone', {
  callback = function()
    local reason = vim.api.nvim_get_vvar('event').reason --- @type string
    if reason == 'accept' then
      local completed_item = vim.api.nvim_get_vvar 'completed_item'
      print(vim.inspect(completed_item))
      print(vim.json.encode(completed_item))
    end
  end,
})

-- LIARSSSS
local _ = false and au('UserGettingBored', '*', function(event)
  Inspect(event)
end)

au('TermClose', '*', function()
  vim.api.nvim_feedkeys(vim.keycode '<C-c>', 'n', true)
end, 'Autoclose terminal when [Process Exit $num]')

au(
  'ModeChanged',
  -- Show relative numbers only when they matter (linewise and blockwise
  -- selection) and 'number' is set (avoids horizontal flickering)
  -- '*:[vV\x16]*',
  '*',
  function()
    previous_stats.mode = vim.api.nvim_get_mode().mode
  end,
  'Show relative line numbers'
)

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'tex' },
  callback = function(buf)
    local buf = vim.api.nvim_get_current_buf()
    vim.opt_local.wrap = true
    vim.opt_local.spell = false

    vim.keymap.set({ 's', 'n', 'o', 'v', 'x' }, 'j', 'gj', { buffer = buf, noremap = true, expr = false })
    vim.keymap.set({ 's', 'n', 'o', 'v', 'x' }, 'k', 'gk', { buffer = buf, noremap = true, expr = false })
    vim.keymap.set({ 's', 'n', 'o', 'v', 'x' }, 'gl', 'g$', { buffer = buf, noremap = true, expr = false })
    vim.keymap.set({ 's', 'n', 'o', 'v', 'x' }, 'gh', 'g0', { buffer = buf, noremap = true, expr = false })
    vim.keymap.set({ 's', 'n', 'o', 'v', 'x' }, 'o', 'g$a<enter>', { buffer = buf, noremap = true, expr = false })

    vim.keymap.set({ 's', 'n', 'o', 'v', 'x' }, 'O', 'g0i<enter><left>', { buffer = buf, noremap = true, expr = false })
    vim.schedule(function()
      vim.cmd [[LspDisableLinting]]
    end)
  end,
})

local function disable_linting()
  for _, client in pairs(vim.lsp.get_clients()) do
    -- Disable the diagnostics handler
    client.handlers['textDocument/publishDiagnostics'] = function() end

    -- Clear existing diagnostics for each buffer associated with the client
    for _, buffer in pairs(vim.api.nvim_list_bufs()) do
      vim.diagnostic.reset(nil, buffer)
    end
  end
  vim.notify 'Linting disabled and diagnostics cleared.'
end

-- Function to enable linting by restoring the default `textDocument/publishDiagnostics` handler
-- and forcing a recheck of diagnostics by triggering a buffer change event
local function enable_linting()
  if not THIS_SHIT_IS_BROKEN_WILL_DO_THE_UNDERDEVELOPED_BRAIN_WAY then
    for _, client in pairs(vim.lsp.get_active_clients()) do
      -- Restore the default diagnostics handler
      client.handlers['textDocument/publishDiagnostics'] = vim.lsp.diagnostic.on_publish_diagnostics
    end
    vim.cmd [[LspRestart]] -- XDD
    return
  end
  for _, client in pairs(vim.lsp.get_active_clients()) do
    -- Restore the default diagnostics handler
    client.handlers['textDocument/publishDiagnostics'] = vim.lsp.diagnostic.on_publish_diagnostics

    -- Force a recheck of diagnostics for each buffer associated with the client
    for _, buffer in pairs(vim.api.nvim_list_bufs()) do
      local params = { textDocument = vim.lsp.util.make_text_document_params(buffer) }

      -- Schedule the diagnostics request to ensure it doesn't block the main loop
      vim.schedule(function()
        client.request('textDocument/publishDiagnostics', params, function(err, result, ctx, config)
          -- Check if result is not nil before attempting to process it
          if result then
            vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
          end
        end)
      end)

      -- Trigger a buffer change to force diagnostics to refresh
      vim.api.nvim_buf_call(buffer, function()
        -- Reload the buffer or force a dummy change
        vim.cmd 'edit' -- Reload the buffer
      end)
    end
  end
  print 'Linting enabled and diagnostics refreshed.'
end

vim.api.nvim_create_augroup('FileTypeBrdf', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.brdf', '*.fs', '*.vs' },
  callback = function()
    vim.bo.filetype = 'glsl'
  end,

  group = 'FileTypeBrdf',
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.brdf',
  callback = function()
    vim.bo.filetype = 'glsl'
  end,

  group = 'FileTypeBrdf',
})

vim.api.nvim_create_augroup('FileTypeC', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.c', '*.h' },
  callback = function()
    vim.bo.filetype = 'c'
  end,

  group = 'FileTypeBrdf',
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.conf', 'tmux' },
  callback = function(args)
    vim.schedule(function()
      require('vim.treesitter').stop(args.buf)
      -- vim.cmd [[TSBufDisable highlight]] -- This way needs to 'vim.schedule' it and because of that it bugs if we quickly change buffers

      --   local ts = require 'vim.treesitter'
      --   -- ShowInspect { buf = vim.api.nvim_get_current_buf(), active = require('vim.treesitter').highlighter.active }
      --   -- lua ShowInspect({buf = vim.api.nvim_get_current_buf(),  active = require('vim.treesitter').highlighter.active })
      --   if ts.highlighter and ts.highlighter.active[args.buf] then
      --     ts.highlighter.active[args.buf] = nil
      --   end
    end)
  end,
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = {
    '*.b',
  },
  callback = function()
    vim.schedule(function()
      vim.bo.filetype = 'b'
      vim.api.nvim_command 'set commentstring=//%s'
    end)
  end,
})

vim.api.nvim_create_user_command('LspDisableLinting', disable_linting, {})
vim.api.nvim_create_user_command('LspEnableLinting', enable_linting, {})

local function store_window_layout(win_id)
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    return {
      relative = 'editor',
      width = vim.api.nvim_win_get_width(win_id),
      height = vim.api.nvim_win_get_height(win_id),

      row = vim.api.nvim_win_get_position(win_id)[1],
      col = vim.api.nvim_win_get_position(win_id)[2],
      style = 'minimal',
      border = 'rounded',
    }
  end
end

-- Show window and buffer in current window position
local function show_window(buf_id, layout)
  if not buf_id or not vim.api.nvim_buf_is_valid(buf_id) then
    print('Buffer ' .. buf_id .. ' is not valid!')
    return nil
  end

  -- Check if there's already a window showing this buffer
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf_id then
      vim.api.nvim_set_current_win(win)
      return win
    end
  end

  -- If no existing window found, create new one
  local new_win = vim.api.nvim_open_win(buf_id, true, layout)
  return new_win
end

local function hide_window(win_id)
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local layout = store_window_layout(win_id)
    -- Set buffer options to prevent it from being deleted
    vim.api.nvim_buf_set_option(buf_id, 'bufhidden', 'hide')
    vim.api.nvim_buf_set_option(buf_id, 'buflisted', false)

    -- Hide the window
    vim.api.nvim_win_hide(win_id)

    return buf_id, layout
  end
end

local run_buf = nil
local run_layout = nil
local run_command_in_window = function(cmd)
  -- Run the command and capture its output
  local output = vim.fn.system(cmd)

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Set the buffer's content to the command output
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, '\n'))

  -- Get the current window's dimensions
  local width = vim.api.nvim_get_option 'columns'
  local height = vim.api.nvim_get_option 'lines'

  -- Calculate floating window size
  local win_height = math.ceil(height)
  local win_width = math.ceil(width)
  -- local win_height = math.ceil(height * 0.8 - 4)
  -- local win_width = math.ceil(width * 0.8)

  -- Calculate floating window starting position
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  -- Set up floating window options
  local opts = {
    style = 'minimal',
    relative = 'editor',

    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = 'rounded',
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set buffer keymaps
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  -- vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  -- Set buffer name
  vim.api.nvim_buf_set_name(buf, 'Command Output: ' .. cmd)

  -- Set buffer keymaps
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })

  -- Custom gf mapping
  run_buf = buf
  run_layout = store_window_layout(win)
  Inspect { buf = buf, run_buf = run_buf }
  vim.keymap.set('n', 'gf', function()
    GoToFileUnderCursor()
    vim.api.nvim_win_hide(win)
    run_buf, run_layout = hide_window(win)
  end, { buffer = buf, noremap = true, silent = true })

  vim.keymap.set('n', '<leader>o', function()
    if run_buf == nil or run_layout == nil then
      Inspect { 'you fucked up jk' }
      return
    end
    show_window(run_buf, run_layout)
  end, { noremap = true, silent = true })

  return win, buf
end

-- Function to go to file under cursor
function GoToFileUnderCursor()
  local filename = vim.fn.expand '<cfile>'

  -- Check if the file exists
  if vim.fn.filereadable(filename) == 0 then
    print('File not found: ' .. filename)
    return
  end

  -- Get all windows
  local windows = vim.api.nvim_list_wins()
  local target_win = nil

  -- Find a non-floating window that's not the current one
  for _, win in ipairs(windows) do
    local win_config = vim.api.nvim_win_get_config(win)
    if win_config.relative == '' and win ~= vim.api.nvim_get_current_win() then
      target_win = win
      break
    end
  end

  -- If no suitable window found, create a new one
  if not target_win then
    vim.cmd 'wincmd v' -- Split vertically
    target_win = vim.api.nvim_get_current_win()
  end

  -- Focus the target window
  vim.api.nvim_set_current_win(target_win)

  -- Open the file

  vim.cmd('edit ' .. vim.fn.fnameescape(filename))
end
-- Store window layout before hiding
-- Create the Run command
vim.api.nvim_create_user_command('Run', function(opts)
  run_command_in_window(opts.args)
end, { nargs = '+' })
-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'wrap_spell',
  pattern = { '*.txt', '*.tex', '*.typ', 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
