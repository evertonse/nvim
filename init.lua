-- TODO:
--    [x disabled for now, kinda buggy even with tmux optios ] zen mode needs better interection zindex with neotree
--    [x oil.nvim i think ] find faster neotree for windows
--    [- Could not doit ] configure noice cmdline to enable normal mode on it
--    [x Working fine ] setup inc-rename to work with noice
--    [ ] checkout tabby for neovim and other
--    [x ] config oil.nvim to test it's performance
--    [x] configure mini.surround to surround word with quotes similar to le nvim.surround
--    [x] check keymaps
--    [x win32-yank-bin as the culprit]check why shit be slow these days when moving arround
--    [ done ] check 'c' mapping for mini plugin
--    [ x Some other time ] see about this ---@field public performance?  done cmp.PerformanceConfig
--    [ ] ui select on telescope on normal mode by typing a number
--    [x seem the same I'll keep using mini.surround then I'll see about chaging]see if surround is better than mini.surround
--    [x I'm using auto-session [ ] see the source code later ]:mksession
--    [ ] Search curious about the gui aspect of this: https://github.com/ray-x/guihua.lua

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.user = {
  nerd_font = true,
  transparency = true,
  theme = 'pastel',
  wilder = false,
  inc_rename = true,
  persistence = false, --NOTE: Better note Idk, bugs with Telescope sometimes
  mini_pick = false,
}

-- [[ Setting globals utils functions before any plugin config function has any chance try to use a nil Global function ]]
require 'utils'
-- ShowStringAndWait(TableDump2(vim.g.user))

-- [[ Setting options ]]
require 'options'

vim.schedule(function()
  require 'autocommands'
end)
--
-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
