local M = {}

M.disable_treesitter_highlight_when = function(lang, bufnr)
  if true then
    return false
  end
  local fts = { 'bin', 'odin', 'tmux', 'llvm', 'conf', 'json5', 'json' }
  local buf_ft = vim.bo.filetype
  for i, ft in ipairs(fts) do
    if buf_ft == ft then
      return true
    end
  end

  local buf_name = vim.api.nvim_buf_get_name(bufnr)

  if lang == 'conf' or string.find(buf_name, 'tmux%-') then
    return true
  end

  local info = vim.loop.fs_stat(buf_name)
  local file_size_permitted = (20 * 1024 * 1024)
  local is_large_file = vim.fn.getfsize(buf_name) > file_size_permitted
  local is_large_file = info and (info.size > (20 * 1024 * 1024))

  if is_large_file then
    return true
  end

  local max_line_count = 200 * 1000
  if buf_ft == 'c' then
    max_line_count = 300 * 1000
  end
  if vim.api.nvim_buf_line_count(bufnr) > max_line_count then
    return true
  end

  return false
end

M.tree_toggle = require 'functions.tree-toggle'

return M
