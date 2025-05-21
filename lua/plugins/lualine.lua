-- Shortened mode names (single letter)
local mode_map = {
  ['NORMAL'] = 'N',
  ['INSERT'] = 'I',
  ['VISUAL'] = 'V',
  ['V-LINE'] = 'VL',
  ['V-BLOCK'] = 'X',
  ['REPLACE'] = 'R',
  ['COMMAND'] = 'C',
  ['TERMINAL'] = 'T',
  ['SELECT'] = 'S',
  ['S-LINE'] = 'SL',
  ['S-BLOCK'] = 'SB',
  ['CONFIRM'] = 'CF',
  ['MORE'] = 'M',
  ['EX'] = 'X',
}

-- Fast LSP component
local function lsp_status()
  -- local buf_clients = vim.lsp.get_active_clients()
  local buf_clients = vim.lsp.get_clients { bufnr = 0 }
  if #buf_clients == 0 then
    return ''
  end

  -- Cache client names to avoid recomputing
  local client_names = {}
  for _, client in ipairs(buf_clients) do
    table.insert(client_names, client.name)
  end

  return table.concat(client_names, ',')
end

local function selection_count_faster()
  local mode = vim.fn.mode()
  if not (mode:match '[vV]') then
    return ''
  end

  local start_pos = vim.fn.getpos 'v'
  local end_pos = vim.fn.getpos '.'
  local srow, scol = start_pos[2], start_pos[3]
  local erow, ecol = end_pos[2], end_pos[3]

  -- Normalize direction
  if srow > erow or (srow == erow and scol > ecol) then
    srow, scol, erow, ecol = erow, ecol, srow, scol
  end

  if srow == erow then
    return ecol - scol
  end

  local count = 0
  local lines = vim.api.nvim_buf_get_lines(0, srow - 1, erow, false)
  for i, line in ipairs(lines) do
    if i == 1 then
      count = count + #line:sub(scol)
    elseif i == #lines then
      count = count + #line:sub(1, ecol)
    else
      count = count + #line
    end
  end

  return count
end

local selection_count_slow = function()
  local mode = vim.api.nvim_get_mode().mode

  -- Only calculate in visual modes (v, V, ^V)
  if mode ~= 'v' and mode ~= 'V' and mode ~= '\22' then -- \22 is ^V (visual block)
    return ''
  end

  -- Use built-in Vim function to get the exact character count of selection
  -- This is the fastest way to get accurate character count across all visual modes
  local char_count = vim.fn.wordcount().visual_chars

  -- Fall back to byte count if char count not available (rare edge case)
  if not char_count or char_count == 0 then
    char_count = vim.fn.wordcount().visual_bytes
  end

  return tostring(char_count)
end

-- Selection count component - strictly counts selected characters
local selection_count = {
  selection_count_faster,
  cond = function()
    local mode = vim.api.nvim_get_mode().mode
    -- Only show during visual modes (v, V, ^V)
    return mode == 'v' or mode == 'V' or mode == '\22'
  end,

  color = { fg = '#ff9e64', gui = 'bold' },
}

-- Custom filename with filetype icon
local filename_with_icon = {
  function()
    local filename = vim.fn.expand '%:t'
    if filename == '' then
      return '[No Name]'
    end

    -- Check for devicons
    local devicons_ok, devicons = pcall(require, 'nvim-web-devicons')
    if not devicons_ok then
      print "nvfilenameim-web-devicons not found. File icons won't be shown."
      return filename
    end

    local icon, icon_color = devicons.get_icon_color(filename, vim.fn.expand '%:e')
    if icon then
      -- Return filename with icon
      return icon .. ' ' .. filename
    end

    -- Fallback to just filename if no icon
    return filename
  end,
  path = 1, -- 0: Just filename, 1: Relative path, 2: Absolute path
  shorting_target = 40, -- Shorten if filename is longer than this
  color = { name = 'LualineNormal' },
}

-- Line and column component
local line_column = {
  function()
    local line = vim.fn.line '.'
    local col = vim.fn.virtcol '.'
    return string.format('%3d:%-2d', line, col)
  end,
}

return {
  'nvim-lualine/lualine.nvim',
  event = 'BufWinEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function(opts)
    local lualine = require 'lualine'
    lualine.setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 185, -- Refresh less frequently (1 second)
          tabline = 10000000000,
          winbar = 1000000000,
        },
      },
      sections = {
        --+-------------------------------------------------+
        --| A | B | C                             X | Y | Z |
        --+-------------------------------------------------+
        lualine_a = {
          {
            'mode',
            fmt = function(str)
              return mode_map[str] or str:sub(1, 1)
            end,
          },
        },
        -- lualine_b = { { 'filename', path = 2 } },
        lualine_b = {
          filename_with_icon,
        },
        lualine_c = { { 'branch', color = { name = 'LualineNormal' } }, { 'diff', color = { name = 'LualineNormal' } } },
        lualine_x = {
          { 'encoding', color = { name = 'LualineNormal' } },
          line_column,
          'progress',
        },
        lualine_y = { selection_count },
        lualine_z = { lsp_status },
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    }
  end,
}
