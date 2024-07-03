-- TODO:
--    [ ] zen mode needs better interection zindex with neotree
--    [ ] find faster neotree for windows
--    [ ] configure noice cmdline to enable normal mode on itfind faster neotre for windows
--    [ ] setup inc-rename to work with noice
--    rename o poup
--    checkout tabby for neovim and other
--    config oil.nvim to test it's performance
--    configure mini.surround to surround word with quotes similar to le nvim.surround
--    check keymaps
--    check why shit be slow these days when moving arround
--    check 'c' mapping for mini plugin
--    see about this ---@field public performance? cmp.PerformanceConfig

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.user = {}
vim.g.user.nerd_font = false
vim.g.user.transparency = true
vim.g.user.theme = 'pastel'

-- [[ Setting globals utils functions before any plugin config function has any chance try to use a nil Global function ]]
require 'utils'

-- Create a custom command with command-preview flag
vim.api.nvim_create_user_command('MySubstitute', function(opts)
  vim.cmd(string.format('s/%s/%s/%s', opts.args[1], opts.args[2], opts.args[3] or ''))
end, {
  nargs = '+',
  preview = function(args)
    -- Generate the command to preview
    local cmd = string.format('s/%s/%s/%s', args.args[1], args.args[2], args.args[3] or '')
    -- Execute the command in preview mode
    vim.cmd 'redraw'
    vim.fn.execute(cmd)
  end,
  desc = 'Custom substitute command with preview',
})

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
-- [[ Setting vim cmds ]]
vim.cmd ':set clipboard=""'
vim.cmd ':set display-=msgsep'
vim.cmd ':set nomore'
-- vim.cmd ':set lz' -- Lazy Redraw
-- vim.cmd ':set ttyfast' -- Lazy Redraw
vim.cmd [[ :set iskeyword-=- ]]
vim.loader.enable()

--
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--     vim.lsp.diagnostic.on_publish_diagnostics, {
--         virtual_text = true
--     }
-- )
