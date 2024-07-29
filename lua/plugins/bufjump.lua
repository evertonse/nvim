return {
  'kwkarlwang/bufjump.nvim',
  event = 'VeryLazy',
  lazy = false,
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
    vim.keymap.set('n', '<C-S-o>', function()
      print 'jump backward in same buffer'
      require('bufjump').backward_same_buf()
    end, opts)
    vim.keymap.set('n', '<C-S-B>', function()
      vim.fn.confirm 'jump backward in same buffer'
      --require('bufjump').forward_same_buf()
    end, opts)

    -- IMPORTANT: this is mapped to "ctrl + shift + ."
    -- But, in alacritty, I'm send the escape code for "crtl + shift + ." when I press 'crtl + shift + i'
    -- { key = "I", mods = "Control|Shift", chars = "\u001b[43;5u" }, # crtl + shift + .
    -- stoled from: https://neovim.discourse.group/t/how-can-i-map-ctrl-shift-f5-ctrl-shift-b-ctrl-and-alt-enter/2133/2
    vim.keymap.set('n', '<C-+>', function()
      print 'jump forward in same buffer'
      require('bufjump').forward_same_buf()
    end, opts)
  end,
}
