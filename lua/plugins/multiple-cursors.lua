if false then
  return {
    'mg979/vim-visual-multi',
    -- version = '*', -- Use the latest tagged version
    lazy = false,
    config = function() end,
  }
else
  return {
    'brenton-leighton/multiple-cursors.nvim',
    version = '*', -- Use the latest tagged version
    lazy = false,
    opts = {
      pre_hook = function()
        require('cmp').setup { enabled = false }
        vim.g.minipairs_disable = true
        vim.cmd 'set nocul'
        vim.cmd 'NoMatchParen'
      end,
      post_hook = function()
        require('cmp').setup { enabled = true }
        vim.g.minipairs_disable = false
        vim.cmd 'set cul'
        vim.cmd 'DoMatchParen'
      end,
      custom_key_maps = {
        -- w
        {
          { 'n', 'x' },
          'gw',
          function(_, count)
            if count ~= 0 and vim.api.nvim_get_mode().mode == 'n' then
              vim.cmd('normal! ' .. count)
            end
            require('spider').motion 'w'
          end,
        },

        -- e
        {
          { 'n', 'x' },
          'ge',
          function(_, count)
            if count ~= 0 and vim.api.nvim_get_mode().mode == 'n' then
              vim.cmd('normal! ' .. count)
            end
            require('spider').motion 'e'
          end,
        },
        -- b
        {
          { 'n', 'x' },
          'gb',
          function(_, count)
            if count ~= 0 and vim.api.nvim_get_mode().mode == 'n' then
              vim.cmd('normal! ' .. count)
            end
            require('spider').motion 'b'
          end,
        },
        {
          'n',
          '<Leader>|',
          function()
            require('multiple-cursors').align()
          end,
        },
        {
          'n',
          'sa',
          function(_, count, motion_cmd, char)
            vim.cmd('normal ' .. count .. 'sa' .. motion_cmd .. char)
          end,
          'mc',
        },
      },
    }, -- This causes the plugin setup function to be called
    keys = {
      -- { '<C-h>', '<Cmd>MultipleCursorsAddUp<CR>', mode = { 'n', 'x' }, desc = 'Add cursor and move up' },
      -- { '<C-l>', '<Cmd>MultipleCursorsAddDown<CR>', mode = { 'n', 'x' }, desc = 'Add cursor and move down' },

      { '<C-Up>', '<Cmd>MultipleCursorsAddUp<CR>', mode = { 'n', 'i', 'x' }, desc = 'Add cursor and move up' },
      { '<C-Down>', '<Cmd>MultipleCursorsAddDown<CR>', mode = { 'n', 'i', 'x' }, desc = 'Add cursor and move down' },

      { '<C-LeftMouse>', '<Cmd>MultipleCursorsMouseAddDelete<CR>', mode = { 'n', 'i' }, desc = 'Add or remove cursor' },

      { '<leader><C-N>', '<Cmd>MultipleCursorsAddMatches<CR>', mode = { 'n', 'v', 'x' }, desc = 'Add cursors to cword' },
      { '<C-N>', '<Cmd>MultipleCursorsAddJumpNextMatch<CR>', mode = { 'n', 'v', 'x' }, desc = 'Add cursors to cword' },
      { '<C-P>', '<Cmd>MultipleCursorsJumpNextMatch<CR>', mode = { 'n', 'v', 'x' }, desc = 'Add cursors to cword' },

      -- { '<Leader>A', '<Cmd>MultipleCursorsAddMatchesV<CR>', mode = { 'n', 'x' }, desc = 'Add cursors to cword in previous area' },

      -- { '<Leader>d', '<Cmd>MultipleCursorsAddJumpNextMatch<CR>', mode = { 'n', 'x' }, desc = 'Add cursor and jump to next cword' },
      -- { '<Leader>D', '<Cmd>MultipleCursorsJumpNextMatch<CR>', mode = { 'n', 'x' }, desc = 'Jump to next cword' },

      { '<Leader>L', '<Cmd>MultipleCursorsLock<CR>', mode = { 'n', 'x' }, desc = 'Lock virtual cursors' },
    },
    config = function(opts)
      vim.api.nvim_set_hl(0, 'MultipleCursorsCursor', { bg = '#FFFFFF', fg = '#000000' })
      vim.api.nvim_set_hl(0, 'MultipleCursorsVisual', { bg = '#CCCCCC', fg = '#000000' })

      require('multiple-cursors').setup(opts)

      --
      -- API
      -- require("multiple-cursors").add_cursor(lnum, col, curswant)
      --
    end,
  }
end
