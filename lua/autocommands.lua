vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank { higroup = 'Visual', timeout = 200 }
  end,
})

-- Apperantly " in front of a line in vimscript is a comment?
vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR> 
    
    autocmd WinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
   " autocmd WinNew * :print "hello"
    autocmd FileType qf,nofile,help set nobuflisted
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _tex
    autocmd!
    autocmd FileType tex setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  function! Odin_settings()
    setlocal tabstop=4
    setlocal shiftwidth=4
  endfunction
  autocmd FileType odin call Odin_settings()
  
  "autocmd FileType python :setlocal tabstop=4 shiftwidth=4 expandtab
  "autocmd FileType lua :setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd FileType cpp :setlocal tabstop=4 shiftwidth=4 expandtab



  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd = 
  augroup end


   " Return to last edit position when opening files (You want this!)
  autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

]]

-- vim.cmd [[ autocmd RecordingEnter * set cmdheight=1 |  nmap Q q | echo "recording start" ]]
-- vim.cmd [[ autocmd RecordingEnter * set cmdheight=1 |  nnoremap Q q | echo "recording start" ]]
-- vim.cmd [[ autocmd RecordingEnter * set cmdheight=1 |  nnoremap q <Nop> | echo "recording start" ]]
-- vim.cmd [[ autocmd RecordingLeave * set cmdheight=0 |  nmap q q | echo "recording stop" ]]
-- vim.cmd [[ autocmd RecordingLeave * set cmdheight=0 |  nmap Q @q | echo "recording stop" ]]

-- vim.cmd([[ autocmd FileType *.c nnoremap <buffer> <F5> :wa<CR>:term gcc % -o %:r && ./%:r<CR> ]])
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

vim.cmd [[autocmd FileType bin nnoremap <F5> :%!xxd <CR>]]
vim.cmd [[autocmd FileType bin nnoremap <F6> :%!xxd -r <CR>]]

-- vim.api.nvim_create_autocmd(
--     { "BufRead", "BufNewFile" },
--     { pattern = { "*.txt", "*.md", "*.tex" }, command = "setlocal spell" }
-- )
-- vim.cmd [[autocmd filetype python nnoremap <F5> :w <bar> exec '!python '.shellescape('%')<CR>]]
-- vim.cmd [[autocmd filetype c nnoremap <F5> :w <bar> exec '!gcc '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>]]
-- vim.cmd [[autocmd filetype cpp nnoremap <F5> :w <bar> exec '!g++ '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>]]
vim.cmd [[autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no]]
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

vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('UserAutoClose', { clear = true }),
  callback = clean_up_buffers,
})

-- close quicklist after enter
vim.cmd [[ autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>]]

vim.cmd [[
" autocmd FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
" there are some defaults for image directory and image name, you can change them
" let g:mdip_imgdir = 'img'
" let g:mdip_imgname = 'image'
]]

local yank_history = {}
local function capture_yank()
  local yanked_text = vim.fn.getreg '"'
  table.insert(yank_history, yanked_text)
end

vim.api.nvim_create_augroup('YankCapture', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = 'YankCapture',
  callback = capture_yank,
})

vim.api.nvim_create_autocmd('CmdwinEnter', {
  pattern = '*',
  callback = function()
    local modes = { 'i', 'n' }
    for _, mode in ipairs(modes) do
      vim.api.nvim_buf_set_keymap(0, mode, '<C-f>', '<C-c><Down>', { noremap = true, silent = true })
    end
    vim.api.nvim_buf_set_keymap(0, 'i', '<CR>', '<C-c><CR>', { noremap = true, silent = true })

    if vim.api.nvim_get_mode().mode == 'n' then
      vim.api.nvim_input 'i'
    end

    local close_completion = false
    if close_completion then
      vim.cmd [[pclose]]
    end
  end,
})

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

-- Custom sorter that sorts in reverse order
vim.api.nvim_create_user_command('TelescopeYankHistory', telescope_yank_history, {})

-- Function to open a quickfix window with yank history

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

  local get_selected_location_entry = function()
    local qfl = vim.fn.getqflist()
    local lnum = vim.api.nvim__buf_stats(0).current_lnum
    -- ShowStringAndWait(vim.inspect(qfl))
    -- ShowStringAndWait(vim.inspect(lnum))
    local idx = lnum
    if idx > 0 and idx <= #qfl then
      return qfl[idx]
    else
      return ''
    end
  end

  local choose = function()
    -- vim.fn.setreg('"', get_selected_location_entry().text)
    local data = get_selected_location_entry().user_data
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

vim.api.nvim_create_user_command('YankHistory', show_yank_history_on_quick, {})

local function get_yank_file_path()
  -- Get the current working directory
  local cwd = vim.fn.getcwd()
  -- Define the file path for storing the last yank
  return cwd .. '/.last_yank.txt'
end

local function save_last_yank()
  local yanked_text = vim.fn.getreg '"'
  local yank_file = get_yank_file_path()
  local file = io.open(yank_file, 'w')
  if file then
    file:write(yanked_text)
    file:close()
  end
end

local function load_last_yank()
  local yank_file = get_yank_file_path()
  local file = io.open(yank_file, 'r')
  if file then
    local yanked_text = file:read '*all'
    vim.fn.setreg('"', yanked_text)
    file:close()
  end
end

-- Autocommand to save the last yanked text before exiting Neovim
vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = save_last_yank,
})

-- Autocommand to load the last yanked text when entering Neovim
vim.api.nvim_create_autocmd('VimEnter', {
  callback = load_last_yank,
})

-- Autocmd to apply the mapping when entering the quickfix window
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    -- map <Esc> to close quickfix window
    vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', ':cclose<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':cclose<CR>', { noremap = true, silent = true })
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('1', { clear = true }),
  callback = function()
    vim.cmd [[set formatoptions-=cro]]
    local buf = vim.api.nvim_get_current_buf()
    -- TelescopeResults

    -- 'TelescopePrompt',TelescopeResults
    if vim.bo[buf].filetype == 'TelescopePrompt' then
      assert(false, vim.inspect(vim.bo[buf]))
      vim.cmd [[startinsert]]
    end
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
