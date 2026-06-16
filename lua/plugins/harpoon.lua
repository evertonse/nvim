local old = {
  'ThePrimeagen/harpoon',
  lazy = true,
  enabled = false,
  keys = { { '<A-o>', mode = { 'n', 'v', 'x' } } },
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
  },
  config = function()
    -- require('telescope').load_extension 'harpoon'
    require('harpoon').setup {
      global_settings = {
        -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
        save_on_toggle = true,

        -- saves the harpoon file upon every change. disabling is unrecommended.
        save_on_change = true,

        -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
        enter_on_sendcmd = false,

        -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
        tmux_autoclose_windows = false,

        -- filetypes that you want to prevent from adding to the harpoon list menu.
        excluded_filetypes = { 'harpoon' },

        -- set marks specific to each git branch inside git repository
        mark_branch = false,

        -- enable tabline with harpoon marks
        tabline = false,
        tabline_prefix = '   ',
        tabline_suffix = '   ',
      },
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
    }
  end,
}

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = false,
  config = function(_, opts)
    vim.schedule(function()
      local harpoon = require 'harpoon'
      -- REQUIRED
      vim.schedule(function()
        harpoon:setup()
      end)

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end)
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      for i = 1, 9 do
        vim.keymap.set('n', '<C-' .. i .. '>', function()
          harpoon:list():select(i)
        end)
      end

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-P>', function()
        harpoon:list():prev()
      end)
      vim.keymap.set('n', '<C-N>', function()
        harpoon:list():next()
      end)
      harpoon:extend {
        UI_CREATE = function(cx)
          vim.keymap.set('n', '<C-v>', function()
            harpoon.ui:select_menu_item { vsplit = true }
          end, { buffer = cx.bufnr })

          vim.keymap.set('n', '<C-x>', function()
            harpoon.ui:select_menu_item { split = true }
          end, { buffer = cx.bufnr })

          vim.keymap.set('n', '<C-t>', function()
            harpoon.ui:select_menu_item { tabedit = true }
          end, { buffer = cx.bufnr })
        end,
      }

      local please_use_telescope_picker = false
      if please_use_telescope_picker then
        -- basic telescope configuration
        local ok, config = pcall(require, 'telescope.config')
        if ok then
          local conf = config.values
          local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
              table.insert(file_paths, item.value)
            end

            require('telescope.pickers')
              .new({}, {
                prompt_title = 'Harpoon',
                finder = require('telescope.finders').new_table {
                  results = file_paths,
                },
                previewer = conf.file_previewer {},
                sorter = conf.generic_sorter {},
              })
              :find()
          end

          vim.keymap.set('n', '<C-e>', function()
            toggle_telescope(harpoon:list())
          end, { desc = 'Open harpoon window' })
        end
      end
    end)
  end,
}
