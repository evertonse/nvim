vim.g.user = {}
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.user.nerd_font = false
vim.g.user.transparency = true
vim.g.user.theme =  "pastel"

-- [[ Setting options ]]
require 'options'


-- [[ Basic Keymaps ]]
vim.schedule(function ()
  require 'keymaps'
end)

vim.schedule(function ()
  require 'autocommands'
end)

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
vim.cmd ':set clipboard=""'
vim.cmd ':set laststatus=3'
vim.cmd ':set display-=msgsep'
vim.cmd ':set nomore'

-- vim.cmd ':set lz' -- Lazy Redraw
-- vim.cmd ":set ttyfast" -- Lazy Redraw
vim.treesitter.language.register("c", "*.cl")
vim.treesitter.language.register("c", "*.h")
vim.treesitter.language.register("c", ".h")
vim.treesitter.language.register("c", "cl")

vim.cmd [[ :set iskeyword-=- ]]
vim.cmd [[ :set updatetime=10 ]]

-- vim.loader.enable()
--
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--     vim.lsp.diagnostic.on_publish_diagnostics, {
--         virtual_text = true
--     }
-- )
