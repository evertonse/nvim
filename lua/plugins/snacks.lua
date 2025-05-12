return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  enabled = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = true },
    picker = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false }, -- smooth scroll
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
}
