-- Custom handler to use vim.ui.input instead of quickfix list
-- NOTE: read below for intructions
--    https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/
return {
  { -- LSP Configuration & Plugins
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    'neovim/nvim-lspconfig',
    lazy = true,
    event = {
      'BufReadPost',
      -- 'BufReadCmd',
      -- 'LspAttach',
      -- 'BufNewFile',
      -- 'VimEnter',
    },
    -- event = 'BufReadCmd', -- NOTE: It hangs in the first opned buffer for some reason? I thought it was just an event
    dependencies = require 'plugins.lsp.dependencies',
    config = require 'plugins.lsp.config',
  },
}
