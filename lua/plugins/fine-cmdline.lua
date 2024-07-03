return {
  'VonHeikemen/fine-cmdline.nvim',
  dependencies = {
    { 'MunifTanjim/nui.nvim' },
  },
  lazy = false,
  enabled = false,
  config = function()
    -- vim.api.nvim_set_keymap("n", "<CR>", "<cmd>FineCmdline<CR>", { noremap = true })
    vim.keymap.set({ 'n' }, ':', '<cmd>FineCmdline<CR>', { noremap = true })
    vim.keymap.set({ 'x', 'v' }, ':', ":<C-u>FineCmdline '<,'><CR>", { noremap = true })
  end,
}
