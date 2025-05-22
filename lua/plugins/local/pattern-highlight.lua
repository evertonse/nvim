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

  for group, pattern in pairs(todos) do
    vim.fn.matchadd(group, [[\v<]] .. pattern .. [[>]], 10, -1, { conceal = 0, synID = 'Comment' })
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
    ['Done'] = '(NOTE|WARNING|vim)',
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
