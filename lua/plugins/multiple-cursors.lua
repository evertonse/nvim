local modes = { 'n', 'x', 'v' }
-- local modes = { 'n', 'x' }
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
    -- version = '*', -- Use the latest tagged version
    branch = 'main',
    commit = '8d410c06fad32cc0e3849318e056b308fbaafede',
    lazy = false,
    opts = {
      pre_hook = function()
        require('cmp').setup { enabled = false }
        vim.g.minipairs_disable = true
      end,
      post_hook = function()
        require('cmp').setup { enabled = true }
        vim.g.minipairs_disable = false
      end,
      custom_key_maps = {
        {
          modes,
          '<Leader>sa',
          function(_, count, motion_cmd, char)
            vim.cmd('normal ' .. count .. 'sa' .. motion_cmd .. char)
          end,
          'mc',
        },
        {
          modes,
          'j',
          function()
            require('multiple-cursors.normal_mode.motion').h()
          end,
          'nowrap',
        },
        {
          modes,
          'k',
          function()
            require('multiple-cursors.normal_mode.motion').j()
          end,
          'nowrap',
        },
        {
          modes,
          'l',
          function()
            require('multiple-cursors.normal_mode.motion').k()
          end,
          'nowrap',
        },
        {
          modes,
          ';',
          function()
            require('multiple-cursors.normal_mode.motion').l()
          end,
          'nowrap',
        },

        {
          modes,
          'm',
          function()
            require('multiple-cursors.normal_mode.motion').b()
          end,
          'nowrap',
        },

        {
          modes,
          'M',
          function()
            require('multiple-cursors.normal_mode.motion').B()
          end,
          'nowrap',
        },
        -- w
        {
          modes,
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
          'ga',
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
  }
end
