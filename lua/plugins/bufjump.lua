return {
  'kwkarlwang/bufjump.nvim',
  event = 'VimEnter',
  lazy = false,
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

    -- IMPORTANT(solved, leaving the comment as history documentation): This is mapped to "ctrl + shift + ."
    --          But, in alacritty, I'm send the escape code for "crtl + shift + ." when I press 'crtl + shift + i'
    --          { key = "I", mods = "Control|Shift", chars = "\u001b[43;5u" }, # crtl + shift + .
    --          stoled from: https://neovim.discourse.group/t/how-can-i-map-ctrl-shift-f5-ctrl-shift-b-ctrl-and-alt-enter/2133/2

    -- DONE: Fixed after reading https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296799
    --       Any crtl + shift + <key> can be send as escape code "\u001b".."[" .. ascii_char_code_for_key .. ";5u"
    local back = function()
      print 'jump forward in same buffer'
      require('bufjump').forward_same_buf()
    end
    vim.keymap.set('n', '<C-S-i>', back, opts)
    vim.keymap.set('n', '<C-+>', back, opts)
  end,
}
