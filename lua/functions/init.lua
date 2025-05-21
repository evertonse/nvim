local M = {}

local DEBUG = false
local Inspect = DEBUG and Inspect or function(arg) end
local want_regex = false

M.clear_diagnostics_for_buf = function(bufnr)
  vim.diagnostic.reset(nil, bufnr)
end

M.clear_diagnostics_for_curr_buf = function(bufnr)
  M.clear_diagnostics_for_buf(vim.api.nvim_get_current_buf() or 0)
end

M.is_too_big_for_completions = function(bufnr)
  local cached = vim.b[bufnr].too_big_for_completions
  if cached then
    return cached
  end
  local return_result = function(bool)
    vim.b[bufnr].too_big_for_completions = bool
    return vim.b[bufnr].too_big_for_completions
  end
  local buf_name = vim.api.nvim_buf_get_name(bufnr)
  local info = vim.loop.fs_stat(buf_name)
  local file_size_permitted = 20 * (1024 * 1024)
  -- local is_large_file = vim.fn.getfsize(buf_name) > file_size_permitted
  local is_large_file = false
  if info then
    is_large_file = info.size > file_size_permitted
  end

  if is_large_file then
    return return_result(true)
  end

  return return_result(false)
end

M.disable_treesitter_highlight_when = function(lang, bufnr, buf_ft)
  local cached = vim.b[bufnr].disabled_treesitter
  if cached then
    Inspect { 'cached', buf_ft = buf_ft }
    return cached
  end

  local return_result = function(bool)
    vim.b[bufnr].disabled_treesitter = bool
    return vim.b[bufnr].disabled_treesitter
  end

  local fts = { 'bin', 'odin', 'tmux', 'llvm', 'conf', 'json5', 'json' }
  buf_ft = buf_ft or vim.bo.filetype
  for i, ft in ipairs(fts) do
    if buf_ft == ft then
      Inspect { trace = vim.inspect(debug.traceback()), buf_ft = buf_ft }
      return return_result(true)
    end
  end

  local buf_name = vim.api.nvim_buf_get_name(bufnr)

  if lang == 'conf' or string.find(buf_name, 'tmux%-') then
    vim.b[bufnr].disabled_treesitter = true
    return return_result(true)
  end

  local info = vim.loop.fs_stat(buf_name)
  local file_size_permitted = 100 * (1024 * 1024)
  -- local is_large_file = vim.fn.getfsize(buf_name) > file_size_permitted
  local is_large_file = false
  if info then
    is_large_file = info.size > file_size_permitted
  end

  if is_large_file then
    return return_result(true)
  end

  local max_line_count = 500 * 1000
  if buf_ft == 'c' then
    max_line_count = 750 * 1000
  end
  if vim.api.nvim_buf_line_count(bufnr) > max_line_count then
    return return_result(true)
  end

  return return_result(false)
end

M.disable_regex_highlight_when = function(lang, bufnr, buf_ft)
  local fts = { sh = true, bash = true, zsh = true }

  buf_ft = buf_ft or vim.bo.filetype
  local buf_name = vim.api.nvim_buf_get_name(bufnr)
  local size_permitted = 30 * (1024 * 1024)

  local info = vim.loop.fs_stat(buf_name)
  local is_large = info and (info.size > size_permitted)

  if is_large and fts[buf_ft] then
    return true
  end

  local max_line_count = 300 * 1000
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if (line_count > max_line_count) and fts[buf_ft] then
    return true
  end
  --- Just let the highlighter decide if it wants treesitter or not, but definetely don't want regex lighlight
  return false
end

M.tree_toggle = require 'functions.tree-toggle'

return M
