return {
  'stevearc/aerial.nvim',
  cmd = { 'AerialPrev', 'AerialNext', 'AerialToggle' },
  opts = {
    on_attach = function(bufnr)
      -- Jump forwards/backwards with '{' and '}'
      vim.keymap.set('n', '<C-u>', '<cmd>AerialPrev<CR>', { buffer = bufnr })
      vim.keymap.set('n', '<C-d>', '<cmd>AerialNext<CR>', { buffer = bufnr })
    end,
  },
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
}
