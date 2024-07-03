-- TODO:
--    [ ] zen mode needs better interection zindex with neotree
--    [ ] find faster neotree for windows
--    [ ] configure noice cmdline to enable normal mode on it
--    [ ] find faster neotre for windows
--    [ ] setup inc-rename to work with noice
--    rename o popup
--    checkout tabby for neovim and other
--    config oil.nvim to test it's performance
--    configure mini.surround to surround word with quotes similar to le nvim.surround
--    check keymaps
--    check why shit be slow these days when moving arround
--    check 'c' mapping for mini plugin
--    see about this ---@field public performance? cmp.PerformanceConfig
--    ui select on telescope on normal mode by typing a number
--    see if surround is better than mini.surround
--    Telescope change last value

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.user = {
  nerd_font = true,
  transparency = true,
  theme = 'pastel',
  wilder = false,
  inc_rename = true,
}

-- [[ Setting globals utils functions before any plugin config function has any chance try to use a nil Global function ]]
require 'utils'
-- ShowStringAndWait(TableDump2(vim.g.user))

-- [[ Setting options ]]
require 'options'

vim.schedule(function()
  require 'autocommands'
end)

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
