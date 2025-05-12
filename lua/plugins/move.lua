local function safe_cmd(cmd)
  return function()
    if vim.bo.modifiable and not vim.bo.readonly then
      pcall(vim.cmd, cmd)
    end
  end
end

return {
  -- 'hinell/move.nvim',
  -- 'fedepujol/move.nvim',
  'evertonse/move.nvim',
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

    -- Visual-mode commands
    -- IMPORTANT Would need to fork it to easily make it safe because the author doesn't check if the buffer is modifiable and because of that it give annoying erros, I'm switchin to mini.move and I've checked that it does check for modifiable buffer 12/05/2025
    vim.keymap.set('v', '<A-j>', 'MoveBlock 1', opts)
    vim.keymap.set('v', '<A-k>', 'MoveBlock -1', opts)
    vim.keymap.set('v', '<A-h>', 'MoveHBlock -1', opts)
    vim.keymap.set('v', '<A-l>', 'MoveHBlock 1', opts)
  end,
}
