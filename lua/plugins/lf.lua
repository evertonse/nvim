local use_haoren = true
if use_haoren then
  return {
    'haorenW1025/floatLf-nvim',
    lazy = false,
    config = function(_, opts)
      vim.cmd [[let g:floatLf_autoclose = 1]]

      vim.cmd [[ let g:floatLf_lf_close = 'q']]
      vim.cmd [[ let g:floatLf_lf_open = '<c-o>']]
      vim.cmd [[ let g:floatLf_lf_split = '<c-x>']]
      vim.cmd [[ let g:floatLf_lf_vsplit = '<c-v>']]
      vim.cmd [[ let g:floatLf_lf_tab = '<c-t>']]
    end,
    dependecies = { 'toggleterm.nvim' },
  }
else
  return {
    'lmburns/lf.nvim',
    lazy = false,
    config = function()
      -- This feature will not work if the plugin is lazy-loaded
      vim.g.lf_netrw = 1

      require('lf').setup {
        escape_quit = false,
        border = 'rounded',
      }

      vim.keymap.set('n', '<M-o>', '<Cmd>Lf<CR>')

      -- vim.api.nvim_create_autocmd('LfTermEnter', {
      --   callback = function(a)
      --     vim.api.nvim_buf_set_keymap(a.buf, 't', 'q', 'q', { nowait = true })
      --   end,
      -- })
    end,
    dependecies = { 'toggleterm.nvim' },
  }
end
