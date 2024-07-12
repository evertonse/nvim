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
    vim.keymap.set('n', '9', function()
      require('bufjump').backward()
    end, opts)
    vim.keymap.set('n', '8', function()
      require('bufjump').forward()
    end, opts)
    vim.keymap.set('n', '<C-O>', function()
      require('bufjump').backward_same_buf()
      print 'going in the same buffer'
    end, opts)
    vim.keymap.set('n', '<C-I>', function()
      print 'going in the same buffer'
      require('bufjump').forward_same_buf()
    end, opts)
  end,
}
