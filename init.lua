-- TODO:
--    [x disabled for now, kinda buggy even with tmux optios ] zen mode needs better interection zindex with neotree
--    [x oil.nvim i think ] find faster neotree for windows
--    [- Could not doit ] configure noice cmdline to enable normal mode on it
--    [x Working fine ] setup inc-rename to work with noice
--    [c] checkout tabby for neovim and other
--    [x ] config oil.nvim to test it's performance
--    [x] configure mini.surround to surround word with quotes similar to le nvim.surround
--    [x] check keymaps
--    [x win32-yank-bin as the culprit]check why shit be slow these days when moving arround
--    [ done ] check 'c' mapping for mini plugin
--    [ x Some other time ] see about this ---@field public performance?  done cmp.PerformanceConfig
--    [x seem the same I'll keep using mini.surround then I'll see about chaging]see if surround is better than mini.surround
--    [x I'm using auto-session [ ] see the source code later ]:mksession
--    [ ] ui select on telescope on normal mode by typing a number
--    [ ] Search curious about the gui aspect of this: https://github.com/ray-x/guihua.lua
--    [x] Mini lsp, recording
--    [ ] Create a telescope options to select from yank history
--    [ ] MORE PLUGINS https://github.com/rockerBOO/awesome-neovim#cursorline
--    [ ] Take a look at https://github.com/ggandor/leap.nvim
--    [ ] Take a look at  hop.nvim
--    [ ] Take a look at https://github-wiki-see.page/m/nvim-telescope/telescope.nvim/wiki/Extensions
--    [ ] REFACTOR: Make all keymaps in keymaps, and require 'keymaps'.telescope for example in plugin site

local session_opts = { 'nvim-possession', 'ressession', 'auto-session', 'persistence' }
local surround_opts = { 'mini.surround', 'vim-surround' }

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.self = {
  icons = true,
  nerd_font = true,
  transparency = true,
  theme = 'pastel',
  wilder = false,
  inc_rename = true,
  session_plugin = session_opts[2], --NOTE: Better note Idk, bugs with Telescope sometimes
  mini_pick = false,
  notification_poll_rate = 40,
  -- BufferPaths = {}, -- XXX: SomeHow it does not user when i's on vim.g, too make problems no cap
}

BufferPaths = {}

-- [[ Setting globals utils functions before any plugin config function has any chance try to use a nil Global function ]]
require 'utils'

-- [[ Setting options ]]
require 'options'

-- XXX might be useful `vim.fn.defer`
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
