local float_term = {
  width_percentage = 0.8, -- Assuming these variables are defined elsewhere
  height_percentage = 0.8,
  width_min = 80, -- Assuming these variables are defined elsewhere
  height_min = 20,
}

local float_term_toggle = function()
  local ok, tt = pcall(require, 'toggleterm.terminal')
  if not ok then
    return
  end

  local f = float_term
  f.terminal = f.terminal
    or tt.Terminal:new {
      direction = 'float',
      float_opts = {
        width = math.floor(vim.o.columns * f.width_percentage),
        height = math.floor(vim.o.lines * f.height_percentage),
      },
      on_open = function(term) ---@diagnostic disable-line: unused-local
        vim.cmd 'startinsert!'

        -- Store previous mappings to restore them later if needed
        local buffer_local_mappings = {
          ['<C-o>'] = true,
          ['<C-i>'] = true,
          ['<C-6>'] = true,
          ['<C-^>'] = true,
          ['<C-w>gf'] = true,
          ['gf'] = true,
          -- Add other buffer-changing commands as needed
        }

        -- Create local buffer mappings for buffer navigation keys
        local current_buf = vim.api.nvim_get_current_buf()
        for key, _ in pairs(buffer_local_mappings) do
          vim.api.nvim_buf_set_keymap(
            current_buf,
            'n',
            key,
            -- First find the most recent non-floating window, switch to it, then perform the original keystroke
            [[<cmd>lua require('my_utils').go_to_last_non_floating_win(true, ']]
              .. key
              .. [[')<CR>]],
            { noremap = true, silent = true }
          )

          -- Also map for terminal mode if applicable
          vim.api.nvim_buf_set_keymap(
            current_buf,
            't',
            key,
            [[<C-\><C-n><cmd>lua require('my_utils').go_to_last_non_floating_win(true, ']] .. key .. [[')<CR>]],
            { noremap = true, silent = true }
          )
        end
      end,
    }

  f.terminal.float_opts.width = math.max(f.width_min, math.floor(vim.o.columns * f.width_percentage))
  f.terminal.float_opts.height = math.max(f.height_min, math.floor(vim.o.lines * f.height_percentage))
  f.terminal:toggle()
end

-- Create a utility module for our helper functions
local M = {}

-- Function to find and switch to last non-floating window
M.go_to_last_non_floating_win = function(should_execute_key, key)
  -- Store current window
  local current_win = vim.api.nvim_get_current_win()

  -- Check if current window is floating
  local is_floating = vim.api.nvim_win_get_config(current_win).relative ~= ''

  if is_floating then
    -- Find non-floating windows
    local non_floating_wins = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(win).relative == '' then
        table.insert(non_floating_wins, win)
      end
    end

    -- Find most recently used non-floating window
    local target_win = nil
    if #non_floating_wins > 0 then
      -- Sort by most recently used (this is a simplification, might need refinement)
      table.sort(non_floating_wins, function(a, b)
        return vim.fn.getwininfo(a)[1].winnr > vim.fn.getwininfo(b)[1].winnr
      end)
      target_win = non_floating_wins[1]

      -- Switch to that window
      vim.api.nvim_set_current_win(target_win)

      -- Execute the original key if requested
      if should_execute_key and key then
        vim.cmd('normal! ' .. key)
      end
    else
      -- No non-floating windows found
      print 'No non-floating windows available'
    end
  else
    -- If not in a floating window, just execute the key
    if should_execute_key and key then
      vim.cmd('normal! ' .. key)
    end
  end
end

-- Make the module available
return {
  float_term_toggle = float_term_toggle,
  go_to_last_non_floating_win = M.go_to_last_non_floating_win,
}
