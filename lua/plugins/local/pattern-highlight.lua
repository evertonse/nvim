-- Why this plugin? All the other use getlines from the buf or read the whole buffer to determine some highlights
-- That is unaccpeptable for huge files, which is common for those who inspect generated code or header only libraries
-- matchadd is less powerful in discoverying if it's inside comment in a generic way. The simple but laborious is to so as syntax/ runtime file does. Check for comment inside pattern then serach for your keywords.
-- We could also try to see if treesitter can give us that context and highlight that FAST in a generic way also.

-- Is 'matchadd' is faster than 'highlight' cmd?
local highlight_orig = function(xs)
  local bufnr = vim.api.nvim_get_current_buf()
  for group, pattern in pairs(xs) do
    vim.fn.matchadd(group, [[\v<]] .. pattern .. [[>]], 10, -1, { conceal = 0, synID = 'Comment' })
  end
end

-- PERF: although it's faster than them all, we still should
local function highlight(xs, bufnr)
  local commentstring = vim.bo.commentstring or ''

  -- Remove any formatting placeholders (like %s) and clean up whitespace
  local comment_prefix = commentstring:gsub('%s*%%s%s*', ''):gsub('^%s*', ''):gsub('%s*$', '')

  if comment_prefix == '' then
    return
  end

  -- Add highlights for each pattern, but only within comments
  for group, pattern in pairs(xs) do
    -- FIX: it does work inside a string and doesnt work in /**/ commentstrings
    -- \zs marker tells Vim to start the match from that point
    local comment_pattern = string.format([[.*%s.*\zs\v<%s>]], comment_prefix, pattern)
    -- local comment_pattern = string.format([[%%(\v^\s*%s\s*%%)\@<=<%s>]], comment_prefix, pattern)
    -- local wherever_pattern = string.format([[\zs\v<%s>]], pattern)

    local final_pattern = comment_pattern

    vim.fn.matchadd(group, final_pattern, 10, -1, {
      conceal = 0,
      window = 0,
      priority = 10,
      matchgroup = group,
      synID = 'Comment',
    })
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
    ['Error'] = '(HACK|ERROR|FIXME|FIX)',
    ['Note'] = '(NOTE|WARNING|BEWARE)',
    ['Done'] = '(DONE|IMPORTANT)',
  }

  local filetypes = {
    -- ['@lsp.typemod.variable.defaultLibrary'] = '(vim)',
    ['Type'] = '(vim)',
  }

  -- TODO: Function to highlight TODOs in comments

  -- Create autocmd to highlight TODOs when buffer is loaded or filetype changes
  -- NOTE: don't use bufenter, it'll be lag as it triggers it everytime
  vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
    pattern = '*',
    group = pattern_highlight_group,
    callback = function(args)
      highlight(todos, args.buf)
    end,
  })

  vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = pattern_highlight_group,
    pattern = { 'lua' },
    callback = function(args)
      highlight(filetypes, args.buf)
    end,
  })
end

return M
