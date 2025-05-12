local M = {}

function M.setup()
  local todo_highlight_group = vim.api.nvim_create_augroup('TodoHighlight', { clear = true })
  local xs = {
    -- group, patterns
    ['Todo'] = '(TODO|PERF)',
    ['Error'] = '(HACK|ERROR)',
    ['Warning'] = '(NOTE|WARNING)',
    ['Done'] = '(DONE|IMPORTANT)',
  }

  -- Function to highlight TODOs in comments
  local function highlight_todos()
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
        if match_id.group == 'TodoHighlight' then
          vim.fn.matchdelete(match_id.id, bufnr)
        end
      end
    end)

    for group, pattern in pairs(xs) do
      vim.fn.matchadd(group, [[\v<]] .. pattern .. [[>]], 10, -1, { conceal = 0, synID = 'Comment' })
    end
  end

  -- Create autocmd to highlight TODOs when buffer is loaded or filetype changes
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileType', 'BufEnter' }, {
    group = todo_highlight_group,
    callback = highlight_todos,
  })
end

return M
