return {
  'mbbill/undotree',
  enabled = true,
  lazy = false,
  event = 'BufEnter',
  config = function(self, opts)
    vim.keymap.set('n', '<leader>ut', function()
      vim.cmd [[UndotreeToggle]]
    end, { desc = '[U]ndotree [T]oggle' })
  end,
}
