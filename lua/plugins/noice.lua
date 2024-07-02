return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  enabled = false,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    -- 'rcarriga/nvim-notify',
  },
  opts = {
    routes = {
      {
        view = 'notify',
        -- filter = { event = 'msg_showmode' },
      },
      {
        filter = {
          event = 'notify',
          min_height = 15,
        },
        view = 'split',
      },
    },
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
