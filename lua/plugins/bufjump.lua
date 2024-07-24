return {
  'kwkarlwang/bufjump.nvim',
  event = 'VeryLazy',
  keys = {},
  config = function()
    require('bufjump').setup {
      forward_key = false,
      backward_key = false,
      forward_same_buf_key = false,
      backward_same_buf_key = false,
    }
    local opts = { silent = true, noremap = true }
    vim.keymap.set('n', '<M-9>', function()
      require('bufjump').backward()
    end, opts)
    vim.keymap.set('n', '<M-8>', function()
      require('bufjump').forward()
    end, opts)
    vim.keymap.set('n', '<S-9>', function()
      require('bufjump').backward_same_buf()
      print 'Jump backward in the same buffer'
    end, opts)
    vim.keymap.set('n', '<S-8>', function()
      require('bufjump').forward_same_buf()
      print 'Jump forward in the same buffer'
    end, opts)
  end,
}
