return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    lazy = true,
    event = 'VimEnter',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      -- Better Around/Inside textobjects
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }
      require('mini.git').setup {}
      require('mini.pick').setup {}

      require('mini.align').setup {
        -- see :help mini.align
        mappings = {
          start = 'ga',
          start_with_preview = 'gA',
        },
      }

      local _ = true
        and require('mini.tabline').setup {
          -- Whether to show file icons (requires 'nvim-tree/nvim-web-devicons')
          show_icons = true,

          -- Function which formats the tab label
          -- By default surrounds with space and possibly prepends with icon
          format = nil,

          -- Whether to set Vim's settings for tabline (make it always shown and
          -- allow hidden buffers)
          set_vim_settings = true,

          -- Where to show tabpage section in case of multiple vim tabpages.mini
          -- One of 'left', 'right', 'none'.
          tabpage_section = 'right',
        }

      require('mini.cursorword').setup()
      --[ mini.indentscope ] Disabled, we're using indent_blankline
      -- which does scope highlighting rather than indentlevel highlighting
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

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup {
        -- see `:h MiniSurround.config`.
        search_method = 'cover',
        respect_selection_type = true,
      }

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font

      local lsp_status = function()
        local clients = vim.lsp.get_clients()
        if next(clients) == nil then
          return ''
        end

        local buf_clients = vim.lsp.get_clients()
        local client_names = {}
        for _, client in pairs(buf_clients) do
          table.insert(client_names, client.name)
        end

        return table.concat(client_names, ', ') .. ' '
      end

      statusline.setup {
        use_icons = vim.g.user.nerd_font,
        set_vim_settings = false,
      }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        -- '%2l:%-2v' for LINE:COLUMN and '%3p%%' for percentage through the file
        return lsp_status() .. '%-2l:%-2v %-3p%%'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
