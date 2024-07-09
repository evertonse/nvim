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
  -- Config https://github.com/folke/noice.nvim/blob/main/lua/noice/config/views.lua#L31C1-L56C5
  opts = {
    throttle = 1000 / 60, -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.
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
      inc_rename = vim.g.self.inc_rename, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  },
  config = function(_, opts)
    --@class NoiceConfigViews: table<string, NoiceViewOptions>
    local defaults = require('noice').setup(opts)
    local ok, telescope = pcall(require, 'telescope')
    if not ok then
      return
    end
    telescope.load_extension 'noice'
  end,
}
