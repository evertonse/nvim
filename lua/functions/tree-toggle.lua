local tree_toggle = function(opts)
  if opts and opts.focus_file then
    -- Change to '.' dir which is gonna be related to current focused file
    vim.cmd('cd ' .. '.')
  end

  if vim.g.self.file_tree == 'neo-tree' then
    require('neo-tree.command').execute {
      action = 'focus', -- OPTIONAL, this is the default value
      source = 'filesystem', -- OPTIONAL, this is the default value
      position = 'float',
      toggle = true,
      reveal_file = opts.focus_file, -- path to file or folder to reveal
      reveal_force_cwd = false, -- don't change cwd, we've already handled it
    }
  elseif vim.g.self.file_tree == 'nvim-tree' then
    local api = require 'nvim-tree.api'
    api.tree.toggle {
      find_file = opts.focus_file,
    }

    if true then
      -- Avoid any logic after that for now
      return
    end

    if api.tree.is_visible() then
      api.tree.close {}
    else
      api.tree.open {
        find_file = opts.focus_file,
      }
    end

    local tree_win_id = vim.fn.win_getid(vim.fn.bufwinnr(vim.fn.bufname 'NvimTree'))
    local is_valid_win = vim.api.nvim_win_is_valid(tree_win_id) and api.tree.is_visible()

    if is_valid_win then
      vim.api.nvim_win_set_option(tree_win_id, 'winblend', vim.g.self.is_transparent and 0 or 8) -- Set the highlight group for this window
      -- vim.api.nvim_set_hl(tree_win_id, 'FloatBorder', { bg = '#FFFFFF' })
    end
  end
end

-- Add a directory pop function to go back to previous directory
function pop_directory()
  if vim.g.dir_stack and #vim.g.dir_stack > 0 then
    local previous_dir = table.remove(vim.g.dir_stack)
    vim.cmd('cd ' .. vim.fn.fnameescape(previous_dir))
    print('Changed back to ' .. previous_dir)
  else
    print 'Directory stack is empty'
  end
end

return tree_toggle
