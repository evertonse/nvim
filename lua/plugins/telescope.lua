-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local actions = require 'telescope.actions'
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {

        defaults = {
          vimgrep_arguments = {
            'rg',
            '-L',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
          },
          --פֿ
          prompt_prefix = '   ',
          selection_caret = '  ',
          entry_prefix = '  ',
          selection_strategy = 'reset',
          sorting_strategy = 'ascending',
          layout_strategy = 'horizontal',
          -- path_display = { 'smart' },
          path_display = { 'truncate' },
          -- initial_mode = "normal",
          preview = {
            treesitter = true,
          },
          layout_config = {
            horizontal = {
              prompt_position = 'top',
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_sorter = require('telescope.sorters').get_fuzzy_file,
          file_ignore_patterns = { 'node_modules' },
          generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
          winblend = 0,
          border = {},

          -- borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
          borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
          -- borderchars = {
          --   prompt = { ' ', ' ', '─', '│', '│', ' ', '─', '└' },
          --   results = { '─', ' ', ' ', '│', '┌', '─', ' ', '│' },
          --   preview = { '─', '│', '─', '│', '┬', '┐', '┘', '┴' },
          -- },
          color_devicons = true,
          set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
          file_previewer = require('telescope.previewers').vim_buffer_cat.new,
          grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
          qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
          -- Developer configurations: Not meant for general override
          buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
          -- fzf native
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'ignore_case', -- or "ignore_case" or "respect_case" -- the default case_mode is "smart_case"
          },
          mappings = {
            i = {
              ['<C-p>'] = actions.cycle_history_prev,
              ['<C-n>'] = actions.cycle_history_next,

              ['<A-j>'] = actions.move_selection_next,
              ['<A-k>'] = actions.move_selection_previous,

              -- ["<C-c>"] = actions.close,

              ['<Down>'] = actions.move_selection_next,
              ['<Up>'] = actions.move_selection_previous,

              -- ["<CR>"] = actions.select_default,
              ['<CR>'] = function(data)
                local mode = vim.api.nvim_get_mode().mode
                vim.cmd [[Neotree close]]
                actions.select_default(data)
                if mode == 'i' then
                  vim.cmd [[stopinsert]]
                  return
                end
              end,
              ['<C-l>'] = actions.select_default,
              ['<C-x>'] = actions.select_horizontal,
              ['<C-v>'] = actions.select_vertical,
              ['<C-t>'] = actions.select_tab,

              ['<C-u>'] = actions.preview_scrolling_up,
              ['<C-d>'] = actions.preview_scrolling_down,

              ['<PageUp>'] = actions.results_scrolling_up,
              ['<PageDown>'] = actions.results_scrolling_down,

              ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
              ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
              ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
              ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
              --["<C-l>"] = actions.complete_tag,
              ['<C-_>'] = actions.which_key, -- keys from pressing <C-/>
              ['<esc>'] = function(data)
                local mode = vim.api.nvim_get_mode().mode
                actions.close(data)
                if mode == 'i' then
                  vim.cmd [[stopinsert]]
                  return
                end
              end,
            },

            n = {
              ['<esc>'] = function(data)
                local mode = vim.api.nvim_get_mode().mode
                actions.close(data)
                if mode == 'i' then
                  vim.cmd [[stopinsert]]
                  return
                end
              end,
              ['<CR>'] = function(data)
                local mode = vim.api.nvim_get_mode().mode
                actions.select_default(data)
                vim.cmd [[Neotree close]]
                if mode == 'i' then
                  vim.cmd [[stopinsert]]
                  return
                end
              end,

              ['l'] = actions.select_default,

              ['<C-x>'] = actions.select_horizontal,
              ['<C-v>'] = actions.select_vertical,
              ['<C-t>'] = actions.select_tab,

              ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
              ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
              ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
              ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

              ['n'] = actions.move_selection_next,
              ['p'] = actions.move_selection_previous,

              ['H'] = actions.move_to_top,
              ['M'] = actions.move_to_middle,
              ['L'] = actions.move_to_bottom,

              ['<Down>'] = actions.move_selection_next,
              ['<Up>'] = actions.move_selection_previous,
              ['gg'] = actions.move_to_top,
              ['G'] = actions.move_to_bottom,

              ['<C-u>'] = actions.preview_scrolling_up,
              ['<C-d>'] = actions.preview_scrolling_down,

              ['<PageUp>'] = actions.results_scrolling_up,
              ['<PageDown>'] = actions.results_scrolling_down,

              ['?'] = actions.which_key,
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>hs', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>ks', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sf', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sf', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>F', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>df', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>rf', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>.f', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>of', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
