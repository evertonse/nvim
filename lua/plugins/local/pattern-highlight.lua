-- PERF, although it's faster tam them all, we still should
local function highlight(xs)
  -- Get the current buffer
  local bufnr = vim.api.nvim_get_current_buf()

  -- Get the comment string for nothing, we ain't doing shit it it
  local commentstring = vim.bo.commentstring or ''

  -- Remove any formatting placeholders (like %s)
  local comment_prefix = commentstring:gsub('%s*%%s%s*', ''):gsub('^%s*', ''):gsub('%s*$', '')
  comment_prefix = vim.pesc(comment_prefix)

  -- Try to clear existing TODO highlights safely
  pcall(function()
    for _, match_id in ipairs(vim.fn.getmatches(bufnr)) do
      if match_id.group == 'PatterHighlight' then
        vim.fn.matchdelete(match_id.id, bufnr)
      end
    end
  end)

  for group, pattern in pairs(xs) do
    vim.fn.matchadd(group, [[\v<]] .. pattern .. [[>]], 10, -1, { conceal = 0, synID = 'Comment' })
  end
end
local ts_utils = require 'nvim-treesitter.ts_utils'

local function is_in_comment(pos)
  local node = ts_utils.get_node_at_cursor { pos[1] + 1, pos[2] }
  while node do
    if node:type():match 'comment' then
      return true
    end
    node = node:parent()
  end
  return false
end
local ts = vim.treesitter
local ts_utils = require 'nvim-treesitter.ts_utils'

local function highlight_comments_only(patterns, hl_group)
  local bufnr = vim.api.nvim_get_current_buf()
  local lang = ts.language.get_lang(vim.bo.filetype)
  if not lang then
    return
  end

  local parser = ts.get_parser(bufnr, lang)
  local tree = parser:parse()[1]
  local root = tree:root()

  local query = ts.query.parse(
    lang,
    [[
    (comment) @c
  ]]
  )

  local ns = vim.api.nvim_create_namespace 'pattern_highlight'
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  for id, node in query:iter_captures(root, bufnr, 0, -1) do
    local text = ts.get_node_text(node, bufnr)
    local start_row, start_col, end_row, _ = node:range()

    for group, pattern in pairs(patterns) do
      for s, e in text:gmatch('()' .. pattern .. '()') do
        vim.api.nvim_buf_add_highlight(bufnr, ns, group, start_row, start_col + s - 1, start_col + e - 1)
      end
    end
  end
end

local function highlight_ts(xs, opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local ns = vim.api.nvim_create_namespace 'pattern_highlight'

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for lnum, line in ipairs(lines) do
    for group, pattern in pairs(xs) do
      for s, e in line:gmatch('()' .. pattern .. '()') do
        local col_start, col_end = s - 1, e - 1

        local highlight_this = true

        if opts.only_in_comments then
          highlight_this = is_in_comment { lnum - 1, col_start }
        elseif opts.only_outside_comments then
          highlight_this = not is_in_comment { lnum - 1, col_start }
        end

        if highlight_this then
          vim.api.nvim_buf_add_highlight(bufnr, ns, group, lnum - 1, col_start, col_end)
        end
      end
    end
  end
end

local M = {}
function M.setup()
  local pattern_highlight_group = vim.api.nvim_create_augroup('PatterHighlight', { clear = false })

  local todos = {
    -- Old groups that I've used. You may reuse these
    -- 'MiniHipatternsFixme', 'MiniHipatternsHack', 'MiniHipatternsTodo', 'MiniHipatternsNote', 'MiniHipatternsNote', 'MiniHipatternsNote', 'Done',
    -- group, patterns
    ['Todo'] = '(TODO|PERF)',
    ['Error'] = '(HACK|ERROR|FIXME)',
    ['Note'] = '(NOTE|WARNING)',
    ['Done'] = '(DONE|IMPORTANT)',
  }

  local filetypes = {
    ['vim'] = '(vim)',
  }

  -- TODO: Function to highlight TODOs in comments

  -- Create autocmd to highlight TODOs when buffer is loaded or filetype changes
  -- NOTE: don't use bufenter, it'll be lag as it triggers it everytime
  -- vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  --   pattern = '*',
  --   group = pattern_highlight_group,
  --   callback = function()
  --     highlight(todos)
  --   end,
  -- })

  vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = pattern_highlight_group,
    pattern = { 'lua' },
    callback = function()
      highlight(filetypes)
    end,
  })
end

return M
