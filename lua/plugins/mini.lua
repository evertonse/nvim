local nvim_ok_version = vim.version().major > 0 or (vim.version().major == 0 and vim.version().minor >= 10)

return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    lazy = true,
    enabled = true,
    event = 'VimEnter',
    cmds = vim.g.self.mini_pick and { 'Pick' } or {},
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      -- Better Around/Inside textobjects
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 } -- see :help MiniAi.config
      local _ = vim.g.self.mini_ai and require('mini.git').setup {}
      local _ = vim.g.self.mini_pick
        and require('mini.pick').setup {
          delay = {
            -- Delay between forcing asynchronous behavior
            async = 10,

            -- Delay between computation start and visual feedback about it
            busy = 3,
          },
          -- Keys for performing actions. See `:h MiniPick-actions`.
          mappings = {
            caret_left = '<Left>',
            caret_right = '<Right>',

            choose = '<CR>',
            choose_in_split = '<C-s>',
            choose_in_tabpage = '<C-t>',
            choose_in_vsplit = '<C-v>',
            choose_marked = '<M-CR>',

            delete_char = '<BS>',
            delete_char_right = '<Del>',
            delete_left = '<C-u>',
            delete_word = '<C-w>',

            mark = '<C-x>',
            mark_all = '<C-a>',

            move_down = '<C-n>',
            move_start = '<C-g>',
            move_up = '<C-p>',

            paste = '<C-r>',

            refine = '<C-Space>',
            refine_marked = '<M-Space>',

            scroll_down = '<C-f>',
            scroll_left = '<C-h>',
            scroll_right = '<C-l>',
            scroll_up = '<C-b>',

            stop = '<Esc>',

            toggle_info = '<S-Tab>',
            toggle_preview = '<Tab>',
          },
          -- General options
          options = {
            -- Whether to show content from bottom to top
            content_from_bottom = false,

            -- Whether to cache matches (more speed and memory on repeated prompts)
            use_cache = true,
          },
        } -- telescope alternative

      require('mini.align').setup {
        -- see :help mini.align
        mappings = {
          start = 'ga',
          start_with_preview = 'gA',
        },
      }

      -- No need to copy this inside `setup()`. Will be used automatically.
      local mini_jump_setup = function()
        require('mini.jump').setup {
          -- Module mappings. Use `''` (empty string) to disable one.
          mappings = {
            forward = 'f',
            backward = 'F',
            forward_till = 't',
            backward_till = 'T',
            repeat_jump = ';',
          },

          -- Delay values (in ms) for different functionalities. Set any of them to
          -- a very big number (like 10^7) to virtually disable.
          delay = {
            -- Delay between jump and highlighting all possible jumps
            highlight = 250,

            -- Delay between jump and automatic stop if idle (no jump is done)
            idle_stop = 10000000,
          },

          -- Whether to disable showing non-error feedback
          -- This also affects (purely informational) helper messages shown after
          -- idle time if user input is required.
          silent = false,
        }
      end
      mini_jump_setup()

      local mini_map_setup = function()
        require('mini.map').setup {
          -- Highlight integrations (none by default)
          integrations = {
            require('mini.map').gen_integration.builtin_search(),
            require('mini.map').gen_integration.diff(),
            require('mini.map').gen_integration.diagnostic(),
          },

          -- Symbols used to display data
          symbols = {
            -- Encode symbols. See `:h MiniMap.config` for specification and
            -- `:h MiniMap.gen_encode_symbols` for pre-built ones.
            -- Default: solid blocks with 3x2 resolution.
            encode = nil,

            -- Scrollbar parts for view and line. Use empty string to disable any.
            scroll_line = '█',
            scroll_view = '┃',
          },

          -- Window options
          window = {
            -- Whether window is focusable in normal way (with `wincmd` or mouse)
            focusable = false,

            -- Side to stick ('left' or 'right')
            side = 'right',

            -- Whether to show count of multiple integration highlights
            show_integration_count = true,

            -- Total width
            width = 4,

            -- Value of 'winblend' option
            winblend = 25,

            -- Z-index
            zindex = 10,
          },
        }
      end
      local _ = vim.g.self.mini_map and mini_map_setup()

      local _ = true
        and require('mini.tabline').setup {
          -- Whether to show file icons (requires 'nvim-tree/nvim-web-devicons')
          show_icons = true,

          -- Function which formats the tab labelk
          -- By default surrounds with space and possibly prepends with icon
          format = nil,

          -- Whether to set Vim's settings for tabline (make it always shown and
          -- allow hidden buffers)
          set_vim_settings = true,

          -- Where to show tabpage section in case of multiple vim tabpages.mini
          -- One of 'left', 'right', 'none'.
          tabpage_section = 'right',
        }

      require('mini.cursorword').setup { delay = 400 }
      -- which does scope highlighting rather than indentlevel highlighting
      -- TODO: When current indent from indentblank is MERGED we might come here and disable mini.indentscope
      local _ = false
        and require('mini.indentscope').setup {
          -- Draw options
          priority = 2,
          draw = {
            -- Delay (in ms) between event and start of drawing scope indicator
            delay = 10,

            -- Animation rule for scope's first drawing. A function which, given
            -- next and total step numbers, returns wait time (in ms). See
            -- |MiniIndentscope.gen_animation| for builtin options. To disable
            -- animation, use ``.

            animation = require('mini.indentscope').gen_animation.none(),
            -- Symbol priority. Increase to display on top of more symbols.
            -- priority = 0,
          },

          -- Module mappings. Use `''` (empty string) to disable one.
          mappings = {
            -- Textobjects
            object_scope = 'ii',
            object_scope_with_border = 'ai',

            -- Motions (jump to respective border line; if not present - body line)
            goto_top = '[i',
            goto_bottom = ']i',
          },

          -- Options which control scope computation
          options = {
            -- Type of scope's border: which line(s) with smaller indent to
            -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
            border = 'none',

            -- Whether to use cursor column when computing reference indent.
            -- Useful to see incremental scopes with horizontal cursor movements.
            indent_at_cursor = true,

            -- Whether to first check input line to be a border of adjacent scope.
            -- Use it if you want to place cursor on function header to get scope of
            -- its body.
            try_as_border = true,
          },

          -- Which character to use for drawing scope indicator
          -- symbol = '│',
          symbol = '▏',
        }

      local mini_surround_setup = function()
        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require('mini.surround').setup {
          -- see `:h MiniSurround.config`.
          custom_surroundings = nil,
          mappings = {
            add = 'sa', -- Add surrounding in Normal and Visual modes
            delete = 'sd', -- Delete surrounding
            find = 'sf', -- Find surrounding (to the right)
            find_left = 'sF', -- Find surrounding (to the left)
            highlight = 'sh', -- Highlight surrounding
            replace = 'sc', -- Chande Surrounding
            update_n_lines = 'sn', -- Update `n_lines`

            suffix_last = 'l', -- Suffix to search with "prev" method
            suffix_next = 'n', -- Suffix to search with "next" method
          },
          search_method = 'cover',
          respect_selection_type = true,
        }
      end
      mini_surround_setup()

      -- Use older API for Neovim versions lower than 0.10

      local lsp_servers_attached = function()
        local clients = nvim_ok_version and vim.lsp.get_clients { bufnr = 0 } or vim.lsp.buf_get_clients(0)
        if next(clients) == nil then
          return ''
        end

        local client_names = {}
        for _, client in pairs(clients) do
          table.insert(client_names, client.name)
        end

        return table.concat(client_names, ', ') .. ' '
      end

      local function recording_mode()
        local rec_reg = vim.fn.reg_recording()
        if rec_reg ~= '' then
          return '@' .. rec_reg .. ' '
        else
          return ''
        end
      end

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      local mini_statusline_setup = function()
        -- Simple and easy statusline.
        --  You could remove this setup call if you don't like it,
        --  and try some other statusline plugin
        local statusline = require 'mini.statusline'

        -- set use_icons to true if you have a Nerd Font
        statusline.section_location = function()
          -- '%2l:%-2v' for LINE:COLUMN and '%3p%%' for percentage through the file
          local function escape_status()
            local ok, m = pcall(require, 'better_escape')
            return ok and m.waiting and '✺ ' or ''
          end

          return escape_status() .. '%2l:%-2v %3p%%'
        end

        statusline.section_lsp = function(args)
          return ''
        end

        local old_section_fileinfo = statusline.section_fileinfo
        statusline.section_fileinfo = function(args)
          local lspstring = lsp_servers_attached()
          if lspstring ~= '' then
            lspstring = (vim.g.self.icons and '󰰎 ' or '') .. lspstring
          end
          return recording_mode() .. lspstring .. old_section_fileinfo(args)
        end

        statusline.setup {
          use_icons = vim.g.self.nerd_font,
          set_vim_settings = false,
        }
        vim.cmd [[:set laststatus=3]]
      end
      mini_statusline_setup()

      require('mini.trailspace').setup()

      local mini_hipatterns_setup = function()
        local hipatterns = require 'mini.hipatterns'
        hipatterns.setup {
          highlighters = {
            -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
            hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
            todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
            note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
            excyber = { pattern = '%f[%w]()EXCYBER()%f[%W]', group = 'MiniHipatternsNote' },
            important = { pattern = '%f[%w]()IMPORTANT()%f[%W]', group = 'MiniHipatternsNote' },
            done = { pattern = '%f[%w]()DONE()%f[%W]', group = 'Done' },

            -- Highlight hex color strings (`#rrggbb`) using that color
            hex_color = hipatterns.gen_highlighter.hex_color(),
          },
        }
      end
      mini_hipatterns_setup()
      -- require('mini.animate').setup() -- HORRIBLE
      local TERRIBLE = false -- just for emphasis, at least on wsl
      local _ = TERRIBLE and require('mini.completion').setup()
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
