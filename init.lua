-- TODO:
--    [x disabled for now, kinda buggy even with tmux optios ] zen mode needs better interection zindex with neotree
--    [x oil.nvim i think ] find faster neotree for windows
--    [- Could not doit ] configure noice cmdline to enable normal mode on it
--    [x Working fine ] setup inc-rename to work with noice
--    [x] checkout tabby for neovim and other
--    [x ] config oil.nvim to test it's performance
--    [x] configure mini.surround to surround word with quotes similar to le nvim.surround
--    [x] check keymaps
--    [x win32-yank-bin as the culprit]check why shit be slow these days when moving arround
--    [x done ] check 'c' mapping for mini plugin
--    [x Some other time ] see about this ---@field public performance?  done cmp.PerformanceConfig
--    [x seem the same I'll keep using mini.surround then I'll see about chaging]see if surround is better than mini.surround
--    [x I'm using auto-session [ ] see the source code later ]:mksession
--    [x] ui select on telescope on normal mode by typing a number
--    [ ] Search curious about the gui aspect of this: https://github.com/ray-x/guihua.lua
--    [x] Mini lsp, recording
--    [x] Create a telescope options to select from yank history
--    [ ] MORE PLUGINS https://github.com/rockerBOO/awesome-neovim#cursorline
--    [x] Take a look at https://github.com/ggandor/leap.nvim
--    [x] Take a look at hop.nvim
--    [ ] Take a look at https://github-wiki-see.page/m/nvim-telescope/telescope.nvim/wiki/Extensions
--    [ ] REFACTOR: Make all keymaps in keymaps, and require 'keymaps'.telescope for example in plugin site
--    [ ] See about make named sessions and named tabs
--    [ ] NvimTree bulk renamed/delete and
--    [ ] NvimTree possibly undo (working with trash)
--    [ ] What is git cherrypick?

-- [[ Setting globals utils functions before any plugin config function has any chance try to use a nil Global function ]]
require 'utils'

-- [[ Setting options ]]
require 'options'

-- NOTE: might be useful `vim.fn.defer`
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

-- require('telescope.builtin').resume()
-- local prompt_bufnr = vim.api.nvim_get_current_buf()
--
-- -- | Event                           | Description                                             |
-- -- | ------------------------------- | ------------------------------------------------------- |
-- -- | `User TelescopeFindPre`         | Do it before Telescope creates all the floating windows |
-- -- | `User TelescopePreviewerLoaded` | Do it after Telescope previewer window is created       |
-- -- | `User TelescopeResumePost`      | Do it after Telescope resume action is fully completed  |
--
-- vim.api.nvim_create_autocmd('User TelescopeFindPre', {
--   buffer = prompt_bufnr,
--   once = true,
--   callback = function()
--     print 'User TelescopeResumePost works'
--   end,
-- })
