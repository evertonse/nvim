return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    {
      'smjonas/inc-rename.nvim',
      lazy = false,
      config = function()
        require('inc_rename').setup {
          -- the name of the command
          cmd_name = 'IncRename',
          -- the highlight group used for highlighting the identifier's new name
          hl_group = 'Substitute',
          -- whether an empty new name should be previewed; if false the command preview will be cancelled instead
          preview_empty_name = false,
          -- whether to display a `Renamed m instances in n files` message after a rename operation
          show_message = true,
          -- whether to save the "IncRename" command in the commandline history (set to false to prevent issues with
          -- navigating to older entries that may arise due to the behavior of command preview)
          save_in_cmdline_history = true,
          -- the type of the external input buffer to use (the only supported value is currently "dressing")
          input_buffer_type = nil,
          -- callback to run after renaming, receives the result table (from LSP handler) as an argument
          post_hook = nil,
        }
      end,
    },
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    -- 'rcarriga/nvim-notify',
  },
  opts = {
    views = {
      popupmenu = {
        relative = 'editor',
        zindex = 65,
        -- position = 'auto', -- when auto, then it will be positioned to the cmdline or cursor
        position = 'bottom',
        size = {
          width = 29999,
          height = 'auto',
          max_height = 20,
          -- min_width = 10,
        },
      },
      cmdline_popupmenu = {
        view = 'popupmenu',
        position = 'bottom',
        zindex = 200,
      },
    },
    popupmenu = {
      enabled = false, -- enables the Noice popupmenu UI
      ---@type 'nui'|'cmp'
      backend = 'cmp', -- backend to use to show regular cmdline completions
      ---@type NoicePopupmenuItemKind|false
      -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
      kind_icons = {}, -- set to `false` to disable icons
    },
    cmdline = {
      enabled = true, -- enables the Noice cmdline UI
      -- view = 'cmdline_popup', -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
      position = 'bottom',
      view = 'cmdline_popup',
    },

    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = true, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  },
  config = function(_, opts)
    --@class NoiceConfigViews: table<string, NoiceViewOptions>
    local defaults = require('noice').setup(opts)
  end,
}
