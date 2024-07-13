return {
  'kwkarlwang/bufjump.nvim',
  event = 'VeryLazy',
  config = function()
    require('bufjump').setup {
      -- forward_key = '<C-n>',
      -- backward_key = '<C-p>',
      on_success = nil,
    }
    local opts = { silent = true, noremap = true }
    vim.keymap.set('n', '<M-9>', function()
      require('bufjump').backward()
    end, opts)
    vim.keymap.set('n', '<M-8>', function()
      require('bufjump').forward()
    end, opts)
    vim.keymap.set('n', '<C-9>', function()
      require('bufjump').backward_same_buf()
      print 'Jump backward in the same buffer'
    end, opts)
    vim.keymap.set('n', '<C-0>', function()
      require('bufjump').forward_same_buf()
      print 'Jump forward in the same buffer'
    end, opts)
  end,
}
