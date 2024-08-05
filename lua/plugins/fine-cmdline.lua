local fine_cmdline_keymaps_enabled = true
return {
  'VonHeikemen/fine-cmdline.nvim',
  dependencies = {
    { 'MunifTanjim/nui.nvim' },
  },
  lazy = false,
  enabled = false,
  config = function()
    local fn = require('fine-cmdline').fn
    require('fine-cmdline').setup {
      cmdline = {
        enable_keymaps = fine_cmdline_keymaps_enabled,
        smart_history = true,
        prompt = ': ',
      },

      popup = {
        relative = 'editor',
        position = {
          row = '10%',
          col = '50%',
        },
        size = {
          width = '60%',
        },
        border = {
          style = 'rounded',
        },
        win_options = {
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
        },
      },
      hooks = {
        before_mount = function(input)
          vim.o.completeopt = 'menu,menuone,noinsert,noselect,preview'
        end,

        after_mount = function(input)
          local opts = { buffer = input.bufnr }
          vim.keymap.set('i', '<Esc>', fn.close, opts)
          vim.keymap.set('i', '<C-c>', '<cmd>stopinsert<cr>', opts)
          vim.keymap.set('i', '<Enter>', '<cmd>stopinsert<cr>', opts)
          vim.keymap.set('i', 'jk', '<cmd>stopinsert<cr>', opts)
          -- Close the input in normal mode
          vim.keymap.set('n', '<C-c>', fn.close, opts)
          vim.keymap.set('n', '<Esc>', fn.close, opts)
        end,

        set_keymaps = function(imap, feedkeys)
          imap('<C-k>', fn.up_search_history)
          imap('<C-j>', fn.down_search_history)
          imap('<Up>', fn.up_history)
          imap('<Down>', fn.down_history)
        end,
      },
    }
    -- vim.api.nvim_set_keymap("n", "<CR>", "<cmd>FineCmdline<CR>", { noremap = true })
    local _ = fine_cmdline_keymaps_enabled and vim.keymap.set({ 'n' }, ':', '<cmd>FineCmdline<CR>', { noremap = true })
    local _ = fine_cmdline_keymaps_enabled and vim.keymap.set({ 'x', 'v' }, ':', ":<C-u>FineCmdline '<,'><CR>", { noremap = true })
  end,
}
