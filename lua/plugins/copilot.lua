return {
  'zbirenbaum/copilot.lua', -- Copilot but lua
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = '[[',
          jump_next = ']]',
          accept = '<CR>',
          refresh = 'gr',
          open = '<leader>ck',
        },
        layout = { position = 'bottom', ratio = 0.4 },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = '<C-y>',
          accept_word = false,
          accept_line = '<C-q>',
          next = false,
          prev = false,
          dismiss = '<C-c>',
        },
      },
      copilot_node_command = 'node',
    }

    vim.keymap.set('n', '<leader>ck', '<cmd>lua require("copilot.suggestion").toggle_auto_trigger()<cr>')
  end,
}
