-- NOTE: For dot-repeat to work, you have to call the motions as Ex-commands.
-- When using function() require("spider").motion("w") end as third argument of the keymap, dot-repeatability will not work
return {
  'chrisgrieser/nvim-spider',
  keys = { 'gw', 'ge', 'gb', mode = { 'n', 'v', 'x' } },
  lazy = true,
  opts = {
    skipInsignificantPunctuation = true,
    consistentOperatorPending = false, -- see "Consistent Operator-pending Mode" in the README
    subwordMovement = true,
    customPatterns = {}, -- check "Custom Movement Patterns" in the README for details
  },
  config = function(_, opts)
    require('spider').setup { opts }
    vim.keymap.set({ 'n', 'v', 'x' }, 'gw', "<cmd>lua require('spider').motion('w')<CR>", { desc = 'Spider-w' })
    vim.keymap.set({ 'n', 'v', 'x' }, 'ge', "<cmd>lua require('spider').motion('e')<CR>", { desc = 'Spider-e' })
    vim.keymap.set({ 'n', 'v', 'x' }, 'gb', "<cmd>lua require('spider').motion('b')<CR>", { desc = 'Spider-b' })
  end,
}
