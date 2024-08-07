return {
  'pogyomo/submode.nvim',
  lazy = false,
  dependencies = {
    'pogyomo/winresize.nvim',
  },
  config = function()
    local submode = require 'submode'
    vim.schedule(function()
      submode.create('trails', {
        mode = 'n',
        enter = '<Leader>M',
        leave = { 'q', '<ESC>' },
        default = function(register)
          register('i', function()
            JumpPosition(1)
          end)
          register('o', function()
            JumpPosition(-1)
          end)
          register('n', function()
            JumpPosition(1)
          end)
          register('p', function()
            JumpPosition(-1)
          end)
        end,
      })
    end)
    local resize = require('winresize').resize
    submode.create('WinResize', {
      mode = 'n',
      enter = '<Leader><C-w>',
      leave = { 'q', '<ESC>' },
      default = function(register)
        register('h', function()
          resize(0, 2, 'left')
        end)
        register('j', function()
          resize(0, 1, 'down')
        end)
        register('k', function()
          resize(0, 1, 'up')
        end)
        register('l', function()
          resize(0, 2, 'right')
        end)
      end,
    })
  end,
}
