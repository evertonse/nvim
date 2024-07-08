-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin
local commit_working_path_support = 'bfcc7d5c6f12209139f175e6123a7b7de6d9c18a'
local commit_working_path_support_branch = 'master'

local select_nth_entry = function(nth)
  return function(prompt_bufnr)
    -- vim.api.nvim_input(':' .. tostring(nth))
    local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
    picker:set_selection(nth)
    vim.cmd [[stopinsert]]

    -- require('telescope.actions').select_default(prompt_bufnr)
  end
end

-- local entry_display = require 'telescope.pickers.entry_display'
-- local make_entry = require 'telescope.make_entry'

-- Custom make_display function for find_files
-- Custom entry maker function
local function custom_entry_maker(entry, index)
  local prefix = index <= 9 and index .. ': ' or ''
  local display_text = prefix .. entry

  return {
    value = entry,
    display = display_text,
    ordinal = entry,
  }
end

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    -- lazy = false,
    -- tag = '0.1.8',
    branch = commit_working_path_support_branch,
    commit = commit_working_path_support,
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',
        -- build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',

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
      local select_default = function(data)
        local mode = vim.api.nvim_get_mode().mode
        -- vim.cmd [[Neotree close]]
        actions.select_default(data)
        if mode == 'i' then
          vim.cmd [[stopinsert]]
          return
        end
      end
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

      -- https://github-wiki-see.page/m/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes
      local previewers = require 'telescope.previewers'
      local Job = require 'plenary.job'
      local _bad = { '.*%.csv' } -- Put all filetypes that slow you down in this array
      local bad_files = function(filepath)
        for _, v in ipairs(_bad) do
          if filepath:match(v) then
            return false
          end
        end
        return true
      end

      ---@diagnostic disable-next-line: redefined-local
      local new_maker = function(filepath, bufnr, opts)
        opts = opts or {}
        if opts.use_ft_detect == nil then
          opts.use_ft_detect = true
        end
        opts.use_ft_detect = opts.use_ft_detect == false and false or bad_files(filepath)
        filepath = vim.fn.expand(filepath)

        Job:new({
          command = 'file',
          args = { '--mime-type', '-b', filepath },
          on_exit = function(j)
            local mime_type = vim.split(j:result()[1], '/')[1]
            if mime_type == 'text' then
              vim.loop.fs_stat(filepath, function(_, stat)
                if not stat then
                  return
                end
                if stat.size > 100000 then
                  vim.schedule(function()
                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'FILE TOO LARGE' })
                  end)
                else
                  previewers.buffer_previewer_maker(filepath, bufnr, opts)
                end
              end)
            else
              -- maybe we want to write something to the buffer here
              vim.schedule(function()
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'BINARY' })
              end)
            end
          end,
        }):sync()
      end
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      local close_telescope = function(data)
        local mode = vim.api.nvim_get_mode().mode
        actions.close(data)
        if mode == 'i' then
          vim.cmd [[stopinsert]]
          return
        end
      end
      -- NOTE: :help telecope.setup() and :help telescope.builtin
      require('telescope').setup {
        pickers = {
          find_files = {

            find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git', '--color=never' },
            -- entry_maker = function(entry)
            --   -- Customize the display of each entry
            --   local icon = ' ' -- Example icon (you can use any icon here)
            --   local display = icon .. entry
            --   -- assert(false)
            --
            --   return {
            --     value = entry,
            --     ordinal = entry,
            --     display = display,
            --   }
            -- end,
          },
          live_grep = {
            find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' },
          },
        },
        defaults = {
          -- buffer_previewer_maker = new_maker,
          buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
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
          selection_caret = ' ',
          entry_prefix = ' ',
          selection_strategy = 'closest',
          -- sorting_strategy = 'descending',
          sorting_strategy = 'ascending',
          layout_strategy = 'horizontal',
          path_display = { 'smart' },
          -- path_display = { 'truncate' },
          initial_mode = 'normal',
          preview = {
            treesitter = true,
          },
          layout_config = {
            horizontal = {
              prompt_position = 'top',
              preview_width = 0.45,
              results_width = 0.7,
              mirror = false,
            },
            vertical = {
              prompt_position = 'top',
              preview_width = 0.55,
              results_width = 0.8,
              mirror = true,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 170,
          },
          file_sorter = require('telescope.sorters').get_fuzzy_file,
          file_ignore_patterns = { 'node_modules' },
          generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
          winblend = 10,
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
          mappings = {
            i = {
              ["'"] = show_numbers_in_telescope_picker,
              ['1'] = select_nth_entry(1),
              ['2'] = select_nth_entry(2),
              ['3'] = select_nth_entry(3),
              ['4'] = select_nth_entry(4),
              ['5'] = select_nth_entry(5),
              ['6'] = select_nth_entry(6),
              ['7'] = select_nth_entry(7),
              ['8'] = select_nth_entry(8),
              ['9'] = select_nth_entry(9),
              ['0'] = select_nth_entry(10),

              ['<C-p>'] = actions.move_selection_previous,
              ['<C-n>'] = actions.move_selection_next,

              ['<C-o>'] = actions.cycle_history_prev,
              ['<C-i>'] = actions.cycle_history_next,

              ['<c-j>'] = actions.move_selection_next,
              ['<c-k>'] = actions.move_selection_previous,

              -- ["<C-c>"] = actions.close,

              ['<Down>'] = actions.move_selection_next,
              ['<Up>'] = actions.move_selection_previous,

              ['<CR>'] = select_default,
              ['<C-y>'] = select_default,
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
              ['<Esc>'] = function(data)
                local mode = vim.api.nvim_get_mode().mode
                actions.close(data)
                if mode == 'i' then
                  vim.cmd [[stopinsert]]
                  return
                end
              end,
            },

            n = {
              ["'"] = select_nth_entry(0),
              ['1'] = select_nth_entry(1),
              ['2'] = select_nth_entry(2),
              ['3'] = select_nth_entry(3),
              ['4'] = select_nth_entry(4),
              ['5'] = select_nth_entry(5),
              ['6'] = select_nth_entry(6),
              ['7'] = select_nth_entry(7),
              ['8'] = select_nth_entry(8),
              ['9'] = select_nth_entry(9),
              ['0'] = select_nth_entry(10),
              ['<esc>'] = close_telescope,
              ['<leader>q'] = close_telescope,

              ['<CR>'] = select_default,
              ['<C-y>'] = select_default,

              ['<C-p>'] = actions.move_selection_previous,
              ['<C-n>'] = actions.move_selection_next,

              ['<C-o>'] = actions.cycle_history_prev,
              ['<C-i>'] = actions.cycle_history_next,

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
              ['ge'] = actions.move_to_bottom,

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
            require('telescope.themes').get_cursor(),
          },
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      -- This will load fzy_native and have it override the default file sorter
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      local mappings = {
        n = {
          ['<leader>hs'] = {
            function()
              builtin.help_tags { initial_mode = 'insert' }
            end,
            '[S]earch [H]elp',
          },
          ['<leader>sk'] = { builtin.keymaps, '[S]earch [K]eymaps' },
          ['<leader>f'] = {
            function()
              --[[hidden = true]]
              builtin.find_files { no_ignore = true, initial_mode = 'insert' }
            end,
            '[S]earch [F]iles',
          },
          ['<leader>st'] = { builtin.builtin, '[S]earch [S]elect Telescope' },
          ['<leader>sg'] = {
            function()
              builtin.grep_string { initial_mode = 'insert' }
            end,
            '[S]earch current [W]ord',
          },
          ['<leader>F'] = {
            function()
              builtin.live_grep { initial_mode = 'insert' }
            end,
            '[S]earch by [G]rep',
          },
          ['<leader>sd'] = { builtin.diagnostics, '[S]earch [D]iagnostics' },
          ['<leader>srf'] = { builtin.resume, '[S]earch [R]esume' },
          ['<leader>s.'] = { builtin.oldfiles, '[S]earch Recent Files ("." for repeat)' },
          ['<leader>b'] = {
            function()
              builtin.buffers { select_current = true }
            end,
            'Find existing [B]uffers',
          },
          -- Slightly advanced example of overriding default behavior and theme
          ['<leader>/'] = {
            function() -- You can pass additional configuration to Telescope to change the theme, layout, etc.
              builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false, initial_mode = 'insert' })
            end,
            '[/] Fuzzily search in current buffer',
          },

          -- It's also possible to pass additional configuration options.
          --  See `:help telescope.builtin.live_grep()` for information about particular keys
          ['<leader>sof'] = {
            function()
              builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files', initial_mode = 'insert' }
            end,
            '[S]earch [/] in Open Files',
          },

          -- Shortcut for searching your Neovim configuration files
          ['<leader>sn'] = {
            function()
              builtin.find_files { cwd = vim.fn.stdpath 'config' }
            end,
            '[S]earch [N]eovim files',
          },
        },
      }
      SetKeyMaps(mappings)
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
