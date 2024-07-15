-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    tag = 'v3.3.0',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    enabled = true,
    opts = {
      ---@type false | "classic" | "modern" | "helix"
      preset = 'helix',
      delay = function(ctx)
        return ctx.plugin and 0 or 120
      end,
      win = {
        -- don't allow the popup to overlap with the cursor
        no_overlap = true,
        -- width = 1,
        -- height = { min = 4, max = 25 },
        -- col = 0,
        -- row = math.huge,
        border = 'none',
        padding = { 1, 0 }, -- extra window padding [top/bottom, right/left]
        title = false,
        title_pos = 'center',
        zindex = 1000,
        -- Additional vim.wo and vim.bo options
        bo = {},
        wo = {
          winblend = 16, -- value between 0-100 0 for fully opaque and 100 for fully transparent
        },
      },
    },
    config = function(_, opts) -- This is the function that runs, AFTER loading
      require('which-key').setup(opts)
    end,
  },
}
