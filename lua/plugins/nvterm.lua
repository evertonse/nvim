return {
  'NvChad/nvterm',
  lazy = false,
  enabled = true,
  config = function()
    --https://github.com/NvChad/nvterm
    local status_ok, nvterm = pcall(require, 'nvterm')
    if not status_ok then
      return false
    end

    nvterm.setup {
      terminals = {
        shell = vim.o.shell,
        list = {},
        type_opts = {
          float = {
            relative = 'editor',
            row = 0.3,
            col = 0.25,
            width = 0.4,
            height = 0.55,
            border = 'single',
          },
          horizontal = {
            location = 'rightbelow',
            split_ratio = 0.5,
            relative = 'editor',
            border = 'single',
          },
          vertical = { location = 'rightbelow', split_ratio = 0.55 },
        },
      },
      behavior = {
        autoclose_on_quit = {
          enabled = false,
          confirm = true,
        },
        close_on_exit = true,
        auto_insert = false,
      },
    }

    local terminal = require 'nvterm.terminal'

    local maps = {
      plugin = true,

      t = {
        -- toggle in terminal mode
        ['<A-i>'] = {
          function()
            require('nvterm.terminal').toggle 'float'
            vim.cmd [[startinsert]]
          end,
          'Toggle floating term',
        },

        ['<A-h>'] = {
          function()
            require('nvterm.terminal').toggle 'horizontal'
          end,
          'Toggle horizontal term',
        },

        ['<A-t>'] = {
          function()
            require('nvterm.terminal').toggle 'vertical'
          end,
          'Toggle vertical term',
        },
      },

      n = {
        -- toggle in normal mode
        ['<A-i>'] = {
          function()
            require('nvterm.terminal').toggle 'float'
          end,
          'Toggle floating term',
        },

        ['<A-h>'] = {
          function()
            require('nvterm.terminal').toggle 'horizontal'
          end,
          'Toggle horizontal term',
        },

        ['<A-v>'] = {
          function()
            require('nvterm.terminal').toggle 'vertical'
          end,
          'Toggle vertical term',
        },

        -- new
        ['<leader><M-h>'] = {
          function()
            require('nvterm.terminal').new 'horizontal'
          end,
          'New horizontal term',
        },

        ['<leader><M-v>'] = {
          function()
            require('nvterm.terminal').new 'vertical'
          end,
          'New vertical term',
        },
        ['<leader><A-i>'] = {
          function()
            -- require("nvterm.terminal").send("exit ", "float") -- the 2nd argument i.e direction is optional
            -- vim.cmd(":bd!")
            require('nvterm.terminal').new 'float'
          end,
          'Toggle floating term',
        },
      },
    }
    local opts = { noremap = true, silent = true }
    for _, mapping in ipairs(maps) do
      vim.keymap.set(mapping[1], mapping[2], mapping[3], opts)
    end
  end,
}
