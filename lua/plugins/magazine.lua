return {
  'iguanacucumber/magazine.nvim',
  name = 'nvim-cmp', -- Otherwise highlighting gets messed up

  event = { 'VimEnter', 'InsertEnter' },
  dependencies = {
    { 'onsails/lspkind.nvim', enabled = true },

    --* the sources *--
    { 'iguanacucumber/mag-nvim-lsp', name = 'cmp-nvim-lsp', opts = {} },
    { 'iguanacucumber/mag-nvim-lua', name = 'cmp-nvim-lua' },
    { 'iguanacucumber/mag-buffer', name = 'cmp-buffer' },
    { 'iguanacucumber/mag-cmdline', name = 'cmp-cmdline' },

    'https://codeberg.org/FelipeLema/cmp-async-path', -- not by me, but better than cmp-path,
  },
}
