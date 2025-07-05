return {
  'max397574/better-escape.nvim',
  -- lazy = false,
  enabled = true,
  event = 'InsertEnter',
  tag = 'v1.0.0',
  -- tag = 'v2.0.0'  is More versatile, but if mapped `jk` to `C-c` in insert mode it keeps leaving a `j` behind, I tried to solve it but it
  -- ain't worth my time, people keep updating shit and breaking shit, so good, but thank god we have a tag
  -- v1.0.0 works just fine, once v2.0.0 reddit reclamation starts maybe i'll change something, for now this is fine
  config = function()
    require('better_escape').setup {
      mapping = {
        'kl',
        'lk',
      }, -- a table with mappings to use
      timeout = vim.o.timeoutlen > 100 and vim.o.timeoutlen or 100, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
      clear_empty_lines = true, -- clear line after escaping if there is only whitespace
      -- keys = '<Esc>', -- keys used for escaping, if it is a function will use the result everytime
      keys = function()
        return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
      end,
    }
  end,
}
