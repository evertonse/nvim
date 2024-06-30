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
