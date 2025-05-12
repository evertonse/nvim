local function safe_cmd(cmd)
  return function()
    if vim.bo.modifiable and not vim.bo.readonly then
      pcall(vim.cmd, cmd)
    end
  end
end

return {
  -- 'hinell/move.nvim',
  'fedepujol/move.nvim',
  tag = 'v2.0.0',
  lazy = true,
  enabled = true,

  keys = {
    { '<A-j>', mode = { 'n', 'v', 'x', 'c' } },
    { '<A-h>', mode = { 'n', 'v', 'x', 'c' } },
    { '<A-k>', mode = { 'n', 'v', 'x', 'c' } },
    { '<A-l>', mode = { 'n', 'v', 'x', 'c' } },
  },
  opts = {
    line = {
      enable = true, -- Enables line movement
      indent = true, -- Toggles indentation
    },
    block = {
      enable = true, -- Enables block movement
      indent = true, -- Toggles indentation
    },
    word = {
      enable = true, -- Enables word movement
    },
    char = {
      enable = false, -- Enables char movement
    },
  },
  config = function(opts)
    require('move').setup(opts)
    local opts = { noremap = true, silent = true }
    -- Normal-mode commands
    vim.keymap.set('n', '<A-j>', safe_cmd 'MoveLine 1', opts)
    vim.keymap.set('n', '<A-h>', safe_cmd 'MoveWord -1', opts)
    vim.keymap.set('n', '<A-k>', safe_cmd 'MoveLine -1', opts)
    vim.keymap.set('n', '<A-l>', safe_cmd 'MoveWord 1', opts)

    -- vim.keymap.set('x', '<A-j>', safe_cmd 'MoveBlock 1', opts)
    -- vim.keymap.set('x', '<A-k>', safe_cmd 'MoveBlock -1', opts)
    -- Visual-mode commands
    vim.keymap.set('v', '<A-h>', safe_cmd 'MoveHBlock -1', opts)
    vim.keymap.set('v', '<A-l>', safe_cmd 'MoveHBlock 1', opts)
  end,
}
