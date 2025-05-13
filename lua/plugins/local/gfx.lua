local M = {}

local goto_file_from_file_line_and_col_number = function(file, line_num, col_num)
  -- Get absolute, resolved path for reliable bufname matching
  local abs = vim.fn.fnamemodify(file, ':p')
  abs = vim.fn.resolve(abs)

  line_num = line_num and tonumber(line_num) or 0
  col_num = col_num and tonumber(col_num) or 0

  -- 1) look through all windows in the current tab
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    if name == abs then
      vim.api.nvim_set_current_win(win)

      if line_num ~= 0 then
        vim.api.nvim_win_set_cursor(win, { line_num, col_num })
      end
      return
    end
  end

  --  not in this tab: is the buffer loaded anywhere?
  local bufnr = vim.fn.bufnr(abs, false) -- false = don’t create
  local target_win = vim.api.nvim_tabpage_list_wins(0)[1]
  vim.api.nvim_set_current_win(target_win)

  if bufnr ~= -1 then
    -- buffer exists, just switch to it
    vim.api.nvim_win_set_buf(target_win, bufnr)
    if line_num ~= 0 then
      vim.api.nvim_win_set_cursor(target_win, { line_num, col_num })
    end
  else
    -- not loaded: edit the file in that window
    file = vim.fn.fnameescape(abs)
    if line_num then
      file = (file .. '|' .. line_num)
    end
    -- Open the file
    vim.cmd('edit ' .. file)
    if line_num ~= 0 then
      vim.api.nvim_win_set_cursor(target_win, { line_num, col_num })
    end
  end
end

-- line_string:string|nil
M.goto_file = function(line_string)
  -- Get the full line or the file/word under cursor
  if not line_string then
    line_string = vim.api.nvim_get_current_line()

    if line_string and line_string == '' then
      line_string = vim.fn.expand '<cfile>'
    end

    if line_string and line_string == '' then
      line_string = vim.fn.expand '<cWORD>'
    end
  end

  -- Parse file and line number with more formats in order or less likely to most likely to match
  -- If match more specified ones, it's probably correct. Once a match is made we accept that.
  local patterns = {
    -- Strange copy form from tmux yank
    -- [[23 ▏   │
    '%[%[%d+%s*([^│%[%]()]+)%s*%[(%d+)%].*:.*',

    -- Shell
    -- sh: <filepath>: line 12: syntax error near unexpected token `else'
    '%s*sh.%s*([^│%[%]():]+)%s*.%s*line%s*(%d+).*',

    -- Python
    --  File "<filepath>", line 334, in <module>
    '%s*File%s*"([^│%[%]():]+)"%s*.%s*line%s*(%d+).*',

    '([^│%[%]()]+)%s*%[(%d+)%].*:.*',
    '([^%[%]()]+)%s*%[(%d+)%].*:.*',
    '.*{([^:()]+)%((%d+):%d+%)}.*',
    '([^:()]+)%((%d+):%d+%).*',

    -- <filepath>:123:123
    '([^:()]+):(%d+):(%d+).*',
    -- <filepath>:123
    '([^:()]+):(%d+).*',
    -- <filepath>|123
    '([^|()]+)|(%d+).*',
    -- <filepath>|
    '([^|()]+).*',
    -- <filepath>
    '([^:()]+).*',
  }

  local file, line_num, col_num
  for _, pattern in ipairs(patterns) do
    file, line_num, col_num = string.match(line_string, pattern)
    -- @Debug
    -- Inspect { idx = idx, file = file, line_string = line_string, pattern = pattern }
    if file then
      local newfile = string.match(file, '.*{([^:()]+)}.*')
      if newfile then
        file = newfile
      end
      break
    end
  end

  if not file then
    vim.notify 'File not found under cursor'
    return
  end

  -- Expand the path
  file = string.gsub(file, '^%s*(.-)%s*$', '%1')
  file = vim.fn.expand(file)

  -- Check if file exists or is readable
  if vim.fn.filereadable(file) ~= 1 then
    vim.notify('File not readable: ' .. file, vim.log.levels.DEBUG)
    local ok = pcall(vim.cmd, [[normal! gF]]) -- Last resource
    if not ok then
      vim.print('File not found: ' .. file)
    end
    return
  end

  -- Get real path
  file = vim.fn.resolve(file)

  -- Check if we're in a floating window
  local win_config = vim.api.nvim_win_get_config(0)
  if win_config.relative ~= '' then
    -- Find a non-floating window
    local windows = vim.api.nvim_list_wins()

    local target_win = nil
    local floating_windows = {}
    -- Close all floating windows
    for _, win in ipairs(windows) do
      local conf = vim.api.nvim_win_get_config(win)
      if conf.relative ~= '' then
        table.insert(floating_windows, win)
      else
        if target_win == nil then
          target_win = win
        end
      end
    end

    -- Switch to the non-floating window
    if target_win then
      for _, win in ipairs(floating_windows) do
        vim.api.nvim_win_close(win, false)
      end
      vim.api.nvim_set_current_win(target_win)
    else
      -- No non-floating window found
      vim.notify('No non-floating window found', vim.log.levels.WARN)
      return
    end
  end

  file = vim.fn.fnameescape(file)

  local use_vim_cmd = false
  if not use_vim_cmd then
    goto_file_from_file_line_and_col_number(file, line_num, col_num)
  else
    if line_num then
      file = (file .. '|' .. line_num)
    end
    -- Open the file
    vim.cmd('edit ' .. file)
  end
  vim.cmd 'normal! zz'
end

M.setup = function()
  GotoFile = M.goto_file
  vim.keymap.set({ 'n', 'v' }, 'gf', function()
    M.goto_file()
  end, { noremap = true, silent = true })
end

return M
