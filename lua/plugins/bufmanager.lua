return {
  'j-morano/buffer_manager.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  event = { 'BufEnter' },
  lazy = true,
  enabled = false,
  config = function()
    require('buffer_manager').setup {}
    vim.keymap.set('n', '<leader>B', ':lua require("buffer_manager.ui").toggle_quick_menu()<CR>', { noremap = true, silent = true })
  end,
}
