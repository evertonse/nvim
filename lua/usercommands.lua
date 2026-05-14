local usercmd = vim.api.nvim_create_user_command

local disable_lsp_current_buffer = function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.stop_client(vim.lsp.getclients { bufnr = bufnr })
  vim.notify 'LSP disabled for current buffer.'
end

local disable_all_lsp = function()
  vim.lsp.stop_client(vim.lsp.get_clients())
  vim.notify 'All LSP servers disabled.'
end

local disable_treesitter_for_current_buffer = function()
  vim.treesitter.stop(vim.api.nvim_get_current_buf())
  vim.cmd 'au! * *treesitter*'
  vim.notify 'All Treesitter highlighting disabled.'
end

local original_comment_highlight = nil
local toggle_brighten_comments = function()
  if original_comment_highlight == nil then
    -- Save the current highlight
    original_comment_highlight = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID 'Comment'), 'fg')

    -- Change
    local color = '#819884'
    -- vim.api.nvim_set_hl(0, 'Comment', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'Comment', { fg = color })
    -- vim.cmd 'hi def link Normal Comment'
    vim.notify 'Comments brightened.'
  else
    -- Restore the original highlight
    vim.cmd('hi Comment guifg=' .. original_comment_highlight)
    original_comment_highlight = nil
    vim.notify 'Comments restored to original color.'
  end
end
usercmd('LspDisable', disable_lsp_current_buffer, {})
usercmd('LspDisableAll', disable_all_lsp, {})
usercmd('TreesitterBufDisable', disable_treesitter_for_current_buffer, {})
usercmd('ToggleBrightenComments', toggle_brighten_comments, {})

vim.api.nvim_create_user_command('RgOpenBuffers', function()
  local dirs = {}
  local files = {}
  local seen = {}

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)

    if not seen[buf] then
      seen[buf] = true

      local name = vim.api.nvim_buf_get_name(buf)

      -- ignore non-file buffers
      if name ~= '' and vim.bo[buf].buftype == '' then
        table.insert(files, vim.fn.fnamemodify(name, ':t'))

        local dir = vim.fn.fnamemodify(name, ':h')
        if dir ~= '' then
          dirs[dir] = true
        end
      end
    end
  end

  if vim.tbl_isempty(files) then
    print 'No visible file-backed buffers'
    return
  end

  local dir_list = vim.tbl_keys(dirs)

  require('telescope.builtin').live_grep {
    search_dirs = dir_list,

    -- search only current visible files
    glob_pattern = '{' .. table.concat(files, ',') .. '}',
  }
end, {})
