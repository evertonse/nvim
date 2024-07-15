BufferPaths = {}

function _TestExtMarks()
  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Set up some lines in the buffer
  local lines = {
    ' First line',
    ' Second line',
    ' Third line',
    ' Fourth line',
    ' Fifth line',
  }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Open the buffer in a new window
  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = 40,
    height = 10,
    row = 5,
    col = 10,
    style = 'minimal',
    border = 'single',
  })

  -- Add ExtMarks to display numbers before each line
  local ns_id = vim.api.nvim_create_namespace 'line_numbers'
  for i, _ in ipairs(lines) do
    local line_number = tostring(i)
    vim.api.nvim_buf_set_extmark(buf, ns_id, i - 1, 0, {
      virt_text = { { line_number, 'Number' } },
      virt_text_pos = 'overlay',
      hl_mode = 'combine',
    })
  end
end

SetKeyMaps = function(mapping_table)
  -- Delete maps do disable
  local set = function(mode, key, mapping)
    local nowait_opts = { noremap = true, silent = true, nowait = true }
    local opts = nowait_opts
    if type(mapping[2]) == 'table' then
      opts = vim.tbl_deep_extend('force', opts, mapping[2])
    elseif type(mapping[2]) == 'string' then
      opts = vim.tbl_deep_extend('force', opts, mapping[3] or {})
      opts.desc = mapping[2]
    else
      opts = { noremap = true, silent = true }
    end
    vim.keymap.set(mode, key, mapping[1], opts)
  end

  for modes, mappings in pairs(mapping_table) do
    for mode in modes:gmatch '.' do
      for key, mapping in pairs(mappings) do
        if mapping == '' then
          pcall(vim.keymap.del, { mode, key })
        else
          set(mode, key, mapping)
        end
      end
    end
  end
end

OnWindows = function()
  local os_name = vim.loop.os_uname().sysname
  local os_version = vim.loop.os_uname().version
  return os_name == 'Windows_NT' or os_version:match 'Windows'
end

OnSlowPath = function()
  local cwd = vim.fn.getcwd()

  local prefixes = { '/mnt/c', '/mnt/d' }

  -- Iterate over the prefixes and check if cwd starts with any of them
  for _, prefix in ipairs(prefixes) do
    if cwd:sub(1, #prefix) == prefix then
      return true
    end
  end

  return false
end

-- Function to customize entry display and handle selection by number
function _TestNumbPicker()
  -- Ensure Telescope is installed
  require 'telescope'
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local sorters = require 'telescope.sorters'
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local opts = {}

  -- Custom entry display with sequence numbers
  local entry_display = require 'telescope.pickers.entry_display'
  local displayer = entry_display.create {
    separator = ' ',
    items = {
      { width = 4 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { tostring(entry.index) .. '.', 'TelescopePromptPrefix' },
      { entry.value, 'TelescopePromptPrefix' },
    }
  end

  -- Sample items for the picker (replace this with your own items)
  local items = { 'First Option', 'Second Option', 'Third Option', 'Fourth Option' }

  for i = 1, #items do
    items[i] = {
      value = items[i],
      ordinal = items[i],
      display = make_display,
      index = i,
    }
  end

  -- Create the picker
  pickers
    .new(opts, {
      prompt_title = 'Numbered Picker',
      finder = finders.new_table {
        results = items,
        entry_maker = function(entry)
          return entry
        end,
      },
      sorter = sorters.get_generic_fuzzy_sorter(),
      attach_mappings = function(prompt_bufnr, map)
        -- Default action for selecting an item
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          print('You selected: ' .. selection.value)
          actions.close(prompt_bufnr)
        end)

        -- Map number keys to select corresponding item
        for i = 1, 9 do
          map('i', tostring(i), function()
            local selection = items[tonumber(i)]
            if selection then
              print('You selected: ' .. selection.value)
              actions.close(prompt_bufnr)
            end
          end)
        end

        return true
      end,
    })
    :find()
end

function TableDump(node)
  local cache, stack, output = {}, {}, {}
  local depth = 1
  local output_str = '{\n'

  while true do
    local size = 0
    for k, v in pairs(node) do
      size = size + 1
    end

    local cur_index = 1
    for k, v in pairs(node) do
      if (cache[node] == nil) or (cur_index >= cache[node]) then
        if string.find(output_str, '}', output_str:len()) then
          output_str = output_str .. ',\n'
        elseif not (string.find(output_str, '\n', output_str:len())) then
          output_str = output_str .. '\n'
        end

        -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
        table.insert(output, output_str)
        output_str = ''

        local key
        if type(k) == 'number' or type(k) == 'boolean' then
          key = '[' .. tostring(k) .. ']'
        else
          key = "['" .. tostring(k) .. "']"
        end

        if v == nil then
          output_str = output_str .. string.rep('\t', depth) .. key .. ' = nil'
        elseif type(v) == 'number' or type(v) == 'boolean' then
          output_str = output_str .. string.rep('\t', depth) .. key .. ' = ' .. tostring(v)
        elseif type(v) == 'table' then
          output_str = output_str .. string.rep('\t', depth) .. key .. ' = {\n'
          table.insert(stack, node)
          table.insert(stack, v)
          cache[node] = cur_index + 1
          break
        elseif type(v) == 'function' then
          output_str = output_str .. string.rep('\t', depth) .. key .. " = '" .. tostring(v) .. "'"
        else
          output_str = output_str .. string.rep('\t', depth) .. key .. " = '" .. tostring(v) .. "'"
        end

        if cur_index == size then
          output_str = output_str .. '\n' .. string.rep('\t', depth - 1) .. '}'
        else
          output_str = output_str .. ','
        end
      else
        -- close the table
        if cur_index == size then
          output_str = output_str .. '\n' .. string.rep('\t', depth - 1) .. '}'
        end
      end

      cur_index = cur_index + 1
    end

    if size == 0 then
      output_str = output_str .. '\n' .. string.rep('\t', depth - 1) .. '}'
    end

    if #stack > 0 then
      node = stack[#stack]
      stack[#stack] = nil
      depth = cache[node] == nil and depth + 1 or depth - 1
    else
      break
    end
  end

  -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
  table.insert(output, output_str)
  output_str = table.concat(output)

  return output_str
end

Inspect = function(table)
  ShowStringAndWait(vim.inspect(table))
end

TestVirtual = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Add ExtMarks to display numbers before each line
  local ns_id = vim.api.nvim_create_namespace 'line_numbers'
  for i = 1, math.min(#lines, 20) do
    local key = 'X'
    vim.api.nvim_buf_set_extmark(bufnr, ns_id, i - 1, 0, {
      virt_text = { { key, 'Number' } },
      -- • virt_text_pos : position of virtual text. Possible values:
      --  • "eol": right after eol character (default).
      --  • "overlay": display over the specified column, without
      --    shifting the underlying text.
      --  • "right_align": display right aligned in the window.
      --  • "inline": display at the specified column, and shift the
      --    buffer text to the right as needed.
      -- virt_text_pos = 'overlay',
      -- end_col = 0,
      virt_text_pos = 'right_align',
      -- virt_text_pos = 'inline',

      -- virt_text_pos = 'eol',
      -- hl_mode = 'blend',
      hl_mode = 'combine',
    })
  end
end

ShowStringAndWait = function(input_string)
  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)

  local lines = {}
  for line in input_string:gmatch '([^\n]*)\n?' do
    table.insert(lines, line)
  end
  -- Set the buffer line with the input string
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
  -- Set the buffer filetype to Lua
  vim.api.nvim_buf_set_option(buf, 'filetype', 'lua')

  -- Get the current window dimensions
  local width = vim.o.columns
  local height = vim.o.lines

  -- Calculate the floating window size
  local win_width = math.ceil(width * 0.8)
  local win_height = math.ceil(height * 0.9)

  -- Calculate the floating window position
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  -- Open the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'single',
  })

  -- Wait for user input to close the window
  vim.api.nvim_command('autocmd BufWipeout <buffer> ++once lua vim.api.nvim_win_close(' .. win .. ', true)')

  -- Set up a keymap to close the window on Enter
  vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '<cmd>q<CR>', { noremap = true, silent = true })
end

--[[
--
-- This file is not required for your own configuration,
-- but helps people determine if their system is setup correctly.
--
--]]
local check_version = function()
  local verstr = string.format('%s.%s.%s', vim.version().major, vim.version().minor, vim.version().patch)
  if not vim.version.cmp then
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end

  if vim.version.cmp(vim.version(), { 0, 9, 4 }) >= 0 then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

function ReverseTable(tbl)
  local size = #tbl
  local reversed = {}
  for i = size, 1, -1 do
    table.insert(reversed, tbl[i])
  end
  return reversed
end

local check_external_reqs = function()
  -- Basic utils: `git`, `make`, `unzip`
  for _, exe in ipairs { 'git', 'make', 'unzip', 'rg' } do
    local is_executable = vim.fn.executable(exe) == 1
    if is_executable then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      vim.health.warn(string.format("Could not find executable: '%s'", exe))
    end
  end

  return true
end

local session_opts = { 'nvim-possession', 'ressession', 'auto-session', 'persistence' }
local surround_opts = { 'mini.surround', 'vim-surround' }
local file_tree_opts = { 'nvim-tree', 'neo-tree' }
vim.g.self = {
  use_minipick_when_slow = OnSlowPath(),
  icons = true,
  nerd_font = true,
  transparency = true,
  theme = 'pastel',
  wilder = false,
  inc_rename = true,
  session_plugin = session_opts[2], --NOTE: Better note Idk, bugs with Telescope sometimes
  mini_map = OnWindows() or OnSlowPath(),
  mini_pick = OnWindows() or OnSlowPath(),
  notification_poll_rate = 80,
  file_tree = file_tree_opts[OnWindows() and 1 or 1],
  open_win_config_recalculate_every_time = true,
  enable_file_tree_preview = false,
  -- BufferPaths = {}, -- XXX: SomeHow it does not user when i's on vim.g, too make problems no cap
}

local function change_to_nvim_config_dir()
  local config_dir = ''
  if vim.fn.has 'win32' == 1 then
    config_dir = vim.fn.expand '$LOCALAPPDATA/nvim'
  else
    config_dir = vim.fn.expand '~/.config/nvim'
  end

  if vim.fn.isdirectory(config_dir) == 1 then
    vim.cmd('tcd ' .. config_dir)
    print('Changed directory to: ' .. config_dir)
  else
    print 'Neovim configuration directory not found.'
  end
end

vim.api.nvim_create_user_command('OpenConfig', change_to_nvim_config_dir, {})

-- Optional: You can also map this to a keybinding, for example:
vim.api.nvim_set_keymap('n', '<leader>cd', ':ChangeToConfigDir<CR>', { noremap = true, silent = true })

return {
  check = function()
    vim.health.start 'kickstart.nvim'

    vim.health.info [[NOTE: Not every warning is a 'must-fix' in `:checkhealth`

    Fix only warnings for plugins and languages you intend to use.
    Mason will give warnings for languages that are not installed.
    You do not need to install, unless you want to use those languages!]]

    local uv = vim.uv or vim.loop
    vim.health.info('System Information: ' .. vim.inspect(uv.os_uname()))

    check_version()
    check_external_reqs()
  end,
}
