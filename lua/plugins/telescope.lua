-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

local preview_width = 0.61
local results_width = 1.0 - preview_width

local them = {
  repo = 'nvim-telescope/telescope.nvim',
  commit_working_path_support = 'b4da76be54691e854d3e0e02c36b0245f945c2c7',
  commit_working_path_support_branch = 'master',
}

local self = {
  repo = 'evertonse/telescope.nvim',
  commit_working_path_support = '964e776d04ae9c9924b2536dffc299125703d103',
  commit_working_path_support_branch = 'master',
}

local using = {
  repo = them.repo,
  commit_working_path_support = them.commit_working_path_support_branch,
  commit_working_path_support_branch = them.commit_working_path_support_branch,
}

local select_nth_entry = function(nth)
  return function(prompt_bufnr)
    -- vim.api.nvim_input(':' .. tostring(nth))
    local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
    picker:set_selection(nth)
    vim.cmd [[stopinsert]]
    vim.cmd [[redraw]]

    require('telescope.actions').select_default(prompt_bufnr)
  end
end

local function custom_find_files()
  -- Define the displayer configuration using entry_display.create()
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local sorters = require 'telescope.sorters'
  local devicons = require 'nvim-web-devicons'
  local entry_display = require 'telescope.pickers.entry_display'
  local displayer = entry_display.create {
    separator = ' ',
    items = {
      { width = 1 }, -- Adjust based on your preference
      { remaining = false },
    },
  }

  local fd_command = {
    'fd',
    '--type',
    'f', -- Only show files
    '--hidden', -- Search hidden files
    '--exclude',
    '.git', -- Exclude .git directory
    '--exclude',
    '.trash', -- Exclude .git directory
    '--exclude',
    '__pycache__', -- Exclude __pycache__ directory
    '--exclude',
    'venv', -- Exclude venv directory
    '--exclude',
    '*.pdf', -- Exclude PDF files
    '--exclude',
    '*.png', -- Exclude PNG files
    '--exclude',
    '*.bin',
    '--exclude',
    '*.exe',
    '--exclude',
    '*.aux',
    '--exclude',
    '*.bbl',
    '--exclude',
    '*.blg',
    '--exclude',
    '*.lot',
    '--exclude',
    '*.brf',
    '--exclude',
    '*.toc',
    '--exclude',
    '*.idx',
    '--exclude',
    '*.lof',
    '--exclude',
    '*~', -- Exclude backupfile
    '--color',
    'never', -- Do not use color output
    '--no-ignore-vcs', -- Show files ignored by VCS
  }

  local rg_command = {
    'rg',
    '--color=never',
    '--no-heading',
    '--with-filename',
    '--line-number',
    '--column',
    '--smart-case',
    '--files',
    '--hidden',
    '-u', -- single unrestrict show git ignored files
    '--glob',
    '!.git/*',
    '--glob',
    '!__pycache__/*',
    '!.trash/*',
    '--glob',
    '!venv/*',
    '--glob',
    '!*.pdf',
    '--glob',
    '!*~', -- backup files
    '--glob',
    '!*.png',
    '--glob',
    '!*.bin',
    '--glob',
    '!*.exe',
    '--glob',
    '!*.aux',
    '--glob',
    '!*.bbl',
    '--glob',
    '!*.blg',
    '--glob',
    '!*.lot',
    '--glob',
    '!*.brf',
    '--glob',
    '!*.toc',
    '--glob',
    '!*.idx',
    '--glob',
    '!*.lof',
  }

  local find_command = {
    'find',
    '.',
    '-type',
    'f',
    '-not',
    '-path',
    '*/.git/*',
    '-not',
    '-path',
    '*/__pycache__/*',
    '-not',
    '-path',
    '*/.trash/*',
    '-not',
    '-path',
    '*/venv/*',
    '-not',
    '-name',
    '*.pdf',
    '-not',
    '-name',
    '*.png',
    '-not',
    '-name',
    '*.bin',
    '-not',
    '-name',
    '*.exe',
    '-not',
    '-name',
    '*~',
    '-not',
    '-name',
    '*.aux',
    '-not',
    '-name',
    '*.bbl',
    '-not',
    '-name',
    '*.blg',
    '-not',
    '-name',
    '*.lot',
    '-not',
    '-name',
    '*.brf',
    '-not',
    '-name',
    '*.toc',
    '-not',
    '-name',
    '*.idx',
    '-not',
    '-name',
    '*.lof',
  }

  local cmds = { fd_command, rg_command, find_command }
  local chosen_command = { find_command }
  for _, cmd in ipairs(cmds) do
    local is_executable = vim.loop.fs_access(vim.fn.exepath(cmd[1]), 'X') or (vim.fn.executable(cmd[1]) == 1)
    if is_executable then
      chosen_command = cmd
      break
    end
  end

  local previewers = require 'telescope.previewers'
  local conf = require('telescope.config').values
  -- NOTE: I'm returning a function because we load all requires in the outer func than we back into the inner function
  -- that way  we don't need to require telescope modules anymore than once
  return function(text)
    pickers
      .new({}, {
        default_text = text,

        layout_config = {
          width = 0.65, -- percentage of screen width
          preview_cutoff = 125, -- Ensure previewer always most times
        },
        -- sorter = conf.generic_sorter {},
        -- sorter = sorters.get_fuzzy_file(),
        sorter = sorters.get_fzy_sorter(),

        previewer = conf.qflist_previewer {},
        -- previewer = previewers.cat.new {}, -- Ugly
        -- previewer = require('telescope.previewers').builtin.new {},
        -- buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
        initial_mode = 'insert',

        debounce = 1,
        prompt_title = 'Find Files (ExCyber)',
        -- finder = finders.new_oneshot_job { 'fd', '--type', 'f', '--hidden', '--exclude', '.git', '--color', 'never' },
        finder = finders.new_oneshot_job(chosen_command, {
          maximum_results = 15, -- I don't think this is used internally
          entry_maker = function(entry)
            local filename = vim.fn.fnamemodify(entry, ':t')
            local icon, icon_highlight = devicons.get_icon(filename, nil, { default = true })
            local icon_color = icon_highlight or 'TelescopeNormal'
            return {
              display = function(display_entry)
                local display_path = vim.fn.fnamemodify(display_entry.path, ':~:.') -- Show relative path
                local win_width = vim.api.nvim_win_get_width(0) -- Get current window width

                -- Adjust the path to fit the window width
                local max_path_width = win_width - 10 -- Adjust as needed to fit icon and spacing
                if #display_path > max_path_width then
                  display_path = '...' .. display_path:sub(-max_path_width)
                end
                local display_color = true
                if not display_color then
                  return icon .. ' ' .. display_entry.path
                else
                  return displayer {
                    { icon, icon_color }, -- Icon with color
                    { ' ' .. display_path, 'TelescopeNormal' }, -- File name with default color
                  }
                end
              end,
              ordinal = entry,
              value = entry,
              path = entry,
            }
          end,
        }),
        -- Set up the display to include devicons
        attach_mappings = function(prompt_bufnr, map)
          local prompt_win = vim.fn.bufwinid(prompt_bufnr)
          vim.schedule(function()
            local is_valid_win = vim.api.nvim_win_is_valid(prompt_win)
            if is_valid_win then
              vim.api.nvim_win_set_option(prompt_win, 'winblend', 0) -- Set the desired winblend for the prompt window
            end
          end)

          if true then
            return true
          end
          -- Automatically select the first entry when the picker opens
          vim.defer_fn(
            function(inner1_prompt_bufnr)
              -- vim.fn.confirm('fuckyou', '&yes\n&no', 2)
              local opts = {
                -- callback = actions.toggle_selection,
                callback = function(inner2_prompt_bufnr)
                  actions.select_default(inner2_prompt_bufnr)
                  -- vim.fn.confirm('fuckyou', '&yes\n&no', 2)
                end,
                -- loop_callback = actions.send_selected_to_qflist,
                -- loop_callback = actions.select_default,
              }
              require('telescope').extensions.hop._hop(prompt_bufnr, opts)
              -- require('telescope').extensions.hop._hop_loop(prompt_bufnr, opts)
            end,
            -- select_nth_entry(prompt_bufnr, 1) -- Select the first entry
            100
          )

          -- Optional: Map additional keys if needed
          map('i', '<C-f>', function()
            -- select_nth_entry(prompt_bufnr, 1)
          end)
        end,
      })
      :find()
  end
end

local telescope_hop = function(prompt_bufnr, opts)
  local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
  local actions = require 'telescope.actions'
  local max_results = picker.max_results
  local num_results = picker.manager:num_results()
  local results_bufnr = picker.results_bufnr
  local sorting_strategy = picker.sorting_strategy

  local buf = results_bufnr
  -- local buf = vim.api.nvim_get_current_buf()

  -- Check if the current buffer is a Telescope picker
  if not (vim.bo[buf].filetype == 'TelescopeResults') then
    print('Current buffer is not a Telescope picker' .. vim.inspect(vim.bo[buf].filetype))
    ShowStringAndWait(vim.inspect(vim.bo[buf]))
    return
  end

  -- Inspect(picker)

  -- Get the lines in the buffer
  -- local keys = { '1', '2','a', 's', 'd', 'f', 'h', 'j', 'k', 'l' }
  local keys = {
    'a',
    's',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
    'q',
    'w',
    'e',
    'r',
    't',
    'y',
    'u',
    'i',
    'o',
    'p',
    'A',
    'S',
    'D',
    'F',
    'G',
    'H',
    'J',
    'K',
    'L',
    ':',
    'Q',
    'W',
    'E',
    'R',
    'T',
    'Y',
    'U',
    'I',
    'O',
    'P',
  }
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  -- Add ExtMarks to display numbers before each line
  local ns_id = vim.api.nvim_create_namespace 'line_numbers'
  local keyline = {}
  for i = 1, math.min(num_results, max_results, #lines, #keys) do
    local key = keys[i]
    local line_number = tostring(i)
    vim.api.nvim_buf_set_extmark(buf, ns_id, i - 1, 0, {
      virt_text = { { key, 'Number' } },
      -- • virt_text_pos : position of virtual text. Possible values:
      --  • "eol": right after eol character (default).
      --  • "overlay": display over the specified column, without
      --    shifting the underlying text.
      --  • "right_align": display right aligned in the window.
      --  • "inline": display at the specified column, and shift the
      --    buffer text to the right as needed.
      -- virt_text_pos = 'overlay',
      end_col = 0,
      -- virt_text_pos = 'right_align',
      virt_text_pos = 'inline',

      -- virt_text_pos = 'eol',
      -- hl_mode = 'blend',
      hl_mode = 'combine',
    })
    keyline[key] = i - 1
  end
  vim.cmd [[redraw]]
  Inspect(opts)

  local char = vim.fn.getchar()
  local key = vim.fn.nr2char(char)
  -- Inspect { char, key }

  if keyline[key] ~= nil then
    vim.api.nvim_buf_clear_namespace(results_bufnr, ns_id, 0, -1)
    picker:set_selection(keyline[key])
    vim.cmd [[redraw]]

    local last_key = vim.fn.nr2char(vim.fn.getchar())
    actions.select_default(prompt_bufnr)
    if last_key == ';' then
    end
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

return { -- Fuzzy Finder (files, lsp, etc)
  using.repo,
  event = 'VeryLazy',
  -- tag = '0.1.8',
  branch = using.commit_working_path_support_branch,
  commit = using.commit_working_path_support,
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
    { 'evertonse/telescope-hop.nvim' },

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
          debounce = 25,
          -- find_command = { 'fd', '--type', 'file', '--hidden', '--no-ignore', '--exclude', '.git', '--color=never' },
          -- find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git', '--exclude', '__pycache__', '--color=never' },
          -- find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git', '--exclude', 'venv', '--exclude', '__pycache__', '--color=never' },
        },
        live_grep = {},
      },
      defaults = {

        attach_mappings = function(prompt_bufnr, map)
          vim.schedule(function()
            local win_id = vim.fn.bufwinid(prompt_bufnr)
            local win_nr = vim.fn.bufwinnr(prompt_bufnr)
            local prompt_win = win_id
            local is_valid_win = vim.api.nvim_win_is_valid(prompt_win)
            if is_valid_win then
              vim.api.nvim_win_set_option(prompt_win, 'winblend', 0) -- Set the desired winblend for the prompt window
              vim.api.nvim_win_set_option(prompt_win, 'signcolumn', 'no')
              vim.api.nvim_win_set_option(prompt_win, 'relativenumber', false)
              vim.api.nvim_win_set_option(prompt_win, 'number', false)
              if vim.version().minor >= 10 then
                vim.api.nvim_get_hl_ns { winid = prompt_win }
              end
            end
          end)
          return true
        end,

        -- buffer_previewer_maker = new_maker,
        buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
        -- vimgrep_arguments = {
        --   'rg',
        --   '-L',
        --   '--color=never',
        --   '--no-heading',
        --   '--with-filename',
        --   '--line-number',
        --   '--column',
        --   '--smart-case',
        -- },
        --פֿ
        prompt_prefix = '  ',
        selection_caret = ' ',
        entry_prefix = ' ',
        --    selection_strategy       Available options are:
        -- - "reset" (default)
        -- - "follow"
        -- - "row"
        -- - "closest"
        -- - "none"

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
            preview_width = preview_width,
            results_width = results_width,
            mirror = false,
          },
          vertical = {
            prompt_position = 'top',
            preview_width = preview_width,
            results_width = results_width,
            mirror = true,
          },
          width = 0.89,
          height = 0.75,
          preview_cutoff = 75,
        },
        -- file_sorter = require('telescope.sorters').get_fuzzy_file,
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        -- file_sorter = require('telescope.sorters').get_levenshtein_sorter,
        -- file_sorter = require('telescope.sorters').get_substr_matcher,
        file_ignore_patterns = { 'node_modules', '.git', '__pycache__', 'venv', '%.png', '%.bin', '%.exe', '~$' },
        generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
        winblend = vim.g.self.is_transparent and 0 or 20,
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
        -- file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        -- grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        -- qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        mappings = {
          i = {
            -- ["'"] = telescope_hop,
            -- ["'"] = function(prompt_bufnr)
            --   -- vim.fn.confirm('fuckyou', '&yes\n&no', 2)
            --   local opts = {
            --     -- callback = actions.toggle_selection,
            --     callback = function(inner_prompt_bufnr)
            --       actions.select_default(inner_prompt_bufnr)
            --       -- vim.fn.confirm('fuckyou', '&yes\n&no', 2)
            --     end,
            --     -- loop_callback = actions.send_selected_to_qflist,
            --     -- loop_callback = actions.select_default,
            --   }
            --   require('telescope').extensions.hop._hop(prompt_bufnr, opts)
            --   -- require('telescope').extensions.hop._hop_loop(prompt_bufnr, opts)
            -- end,
            -- ['1'] = select_nth_entry(1 - 1),
            -- ['2'] = select_nth_entry(2 - 1),
            -- ['3'] = select_nth_entry(3 - 1),
            -- ['4'] = select_nth_entry(4 - 1),
            -- ['5'] = select_nth_entry(5 - 1),
            -- ['6'] = select_nth_entry(6 - 1),
            -- ['7'] = select_nth_entry(7 - 1),
            -- ['8'] = select_nth_entry(8 - 1),
            -- ['9'] = select_nth_entry(9 - 1),

            ['<C-p>'] = actions.move_selection_previous,
            ['<C-n>'] = actions.move_selection_next,

            ['<C-o>'] = actions.cycle_history_prev,
            ['<C-i>'] = actions.cycle_history_next,

            ['<c-j>'] = actions.move_selection_next,
            ['<c-k>'] = actions.move_selection_previous,

            ['<C-c>'] = function()
              vim.cmd [[stopinsert]]
            end,

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
            ['<esc>'] = close_telescope,
            ['<leader>q'] = close_telescope,

            ['<CR>'] = select_default,
            ['<C-y>'] = select_default,

            ['<C-p>'] = actions.move_selection_previous,
            ['<C-n>'] = actions.move_selection_next,

            ['<C-o>'] = actions.cycle_history_prev,
            ['<C-i>'] = actions.cycle_history_next,

            [';'] = actions.select_default,
            ['k'] = actions.move_selection_next,
            ['l'] = actions.move_selection_previous,

            ['s'] = actions.select_horizontal,
            ['v'] = actions.select_vertical,
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
      cache_picker = {
        num_pickers = -1,
        limit_entry = 40,
        ignore_empty_prompt = true,
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
          require('telescope.themes').get_cursor(),
        },
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = false, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf_native')
    -- This will load fzy_native and have it override the default file sorter
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension 'hop')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    local mappings = {
      v = {

        ['<leader>F'] = {
          function()
            local selection = GetVisualSelection()
            builtin.live_grep { initial_mode = 'insert', default_text = selection }
          end,
          '[S]earch by [G]rep',
        },
        ['<leader>f'] = {
          function()
            local selection = GetVisualSelection()
            builtin.find_files { initial_mode = 'insert', default_text = selection }
          end,
          'Search Files',
        },
      },
      n = {
        ['<leader>hs'] = {
          function()
            builtin.help_tags { initial_mode = 'insert' }
          end,
          '[S]earch [H]elp',
        },
        ['<leader>sk'] = { builtin.keymaps, '[S]earch [K]eymaps' },
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
        ['<leader>B'] = {
          function()
            builtin.buffers {
              initial_mode = 'insert',
              select_current = true,
              attach_mappings = function(prompt_bufnr, map)
                if true then
                  return
                end
                vim.defer_fn(
                  function(inner1_prompt_bufnr)
                    -- vim.fn.confirm('fuckyou', '&yes\n&no', 2)
                    local opts = {
                      -- callback = actions.toggle_selection,
                      callback = function(inner2_prompt_bufnr)
                        actions.select_default(inner2_prompt_bufnr)
                        -- vim.fn.confirm('fuckyou', '&yes\n&no', 2)
                      end,
                      -- loop_callback = actions.send_selected_to_qflist,
                      -- loop_callback = actions.select_default,
                    }
                    require('telescope').extensions.hop._hop(prompt_bufnr, opts)
                    -- require('telescope').extensions.hop._hop_loop(prompt_bufnr, opts)
                  end,
                  -- select_nth_entry(prompt_bufnr, 1) -- Select the first entry
                  100
                )
                -- map({ 'i', 'n' }, '<tab>', actions.git_staging_toggle)
                local prompt_win = vim.fn.bufwinid(prompt_bufnr)
                if prompt_win ~= -1 and vim.api.nvim_win_is_valid(prompt_win) then
                  vim.schedule(function()
                    vim.api.nvim_win_set_option(prompt_win, 'winblend', 0) -- Set the desired winblend for the prompt window
                  end)
                end
                return true -- Use Default mappings
              end,
              on_complete = {
                function(_self)
                  assert(false)
                end,
              },
            }
          end,
          'Find existing [B]uffers',
        },
        -- Slightly advanced example of overriding default behavior and theme
        ['<leader>/'] = {
          function() -- You can pass additional configuration to Telescope to change the theme, layout, etc.
            local ok, tthemes = pcall(require, 'telescope.themes')
            if ok then
              local dropdown_ok, dropdown = pcall(tthemes.get_dropdown, {
                winblend = vim.g.self.is_transparent and 0 or 10,
                previewer = false,
                initial_mode = 'insert',
              })
              if dropdown_ok then
                pcall(builtin.current_buffer_fuzzy_find, dropdown)
              end
            end
          end,
          '[/] Fuzzily search in current buffer',
        },

        -- It's also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        ['<leader>sof'] = {
          function()
            builtin.live_grep {
              grep_open_files = true,
              prompt_title = 'Live Grep in Open Files',
              initial_mode = 'insert',
            }
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

    local on_windows = OnWindows()
    if on_windows or OnSlowPath() and vim.g.self.use_minipick_when_slow then
      mappings.n['<leader>f'] = {
        ':Pick files<CR>',
        '[S]earch [F]iles',
      }
    else
      mappings.n['<leader>f'] = {
        (not on_windows) and custom_find_files() or function(text)
          text = builtin.find_files {
            initial_mode = 'insert',
            default_text = text or '',
          }
        end,
        '[S]earch [F]iles',
      }
    end

    SetKeyMaps(mappings)
    local pickers = require 'telescope.builtin'
    pickers.on_resize_window = function(prompt_bufnr)
      print 'telescope rsize'
      assert(false)
    end

    vim.api.nvim_create_autocmd('User', {
      -- pattern = 'TelescopePreviewerLoaded',
      -- pattern = 'TelescopeFindPre',
      -- pattern = 'TelescopeResumePost',
      pattern = 'TelescopeFindPre',
      callback = function(args)
        local prompt_bufnr = args.buf

        vim.defer_fn(function()
          local prompt_win = vim.fn.bufwinid(prompt_bufnr)
          vim.api.nvim_win_set_option(prompt_win, 'winblend', 0) -- Set the desired winblend for the prompt window
          -- Inspect(prompt_win)
        end, 100)
        -- Inspect { args, prompt_win }
      end,
    })
  end,
}
