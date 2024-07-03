SetKeyMaps = function(mapping_table, disable)
  -- Delete maps do disable
  local set = function(mode, key, mapping)
    local nowait_opts = { noremap = true, silent = true, nowait = true }
    local opts = nowait_opts
    if type(mapping[2]) == 'table' then
      opts = vim.tbl_deep_extend('force', mapping[2], opts)
    elseif type(mapping[2]) == 'string' then
      opts = vim.tbl_deep_extend('force', mapping[3] or {}, opts)
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
          vim.keymap.del(mode, key)
        else
          set(mode, key, mapping)
        end
      end
    end
  end
end

-- Function to customize entry display and handle selection by number
function number_entry_picker()
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

-- Create a command to invoke the custom picker
vim.api.nvim_set_keymap('n', '<leader>np', '<cmd>lua number_entry_picker()<CR>', { noremap = true, silent = true })

function TableDump2(node)
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

        if type(v) == 'number' or type(v) == 'boolean' then
          output_str = output_str .. string.rep('\t', depth) .. key .. ' = ' .. tostring(v)
        elseif type(v) == 'table' then
          output_str = output_str .. string.rep('\t', depth) .. key .. ' = {\n'
          table.insert(stack, node)
          table.insert(stack, v)
          cache[node] = cur_index + 1
          break
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

function TableDump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then
        k = '"' .. k .. '"'
      end
      s = s .. '[' .. k .. '] = ' .. TableDump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
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
    border = 'rounded',
  })

  -- Wait for user input to close the window
  vim.api.nvim_command('autocmd BufWipeout <buffer> ++once lua vim.api.nvim_win_close(' .. win .. ', true)')

  -- Set up a keymap to close the window on Enter
  vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '<cmd>q<CR>', { noremap = true, silent = true })

  -- Print a message to the user
  print 'Press Enter to close the window...'
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
