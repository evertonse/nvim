return {
  'VonHeikemen/searchbox.nvim',
  enabled = true,
  lazy = false,
  config = function()
    require('searchbox').setup {
      defaults = {
        reverse = false,
        exact = false,
        prompt = ' ',
        modifier = 'disabled',
        confirm = 'off',
        clear_matches = true,
        show_matches = false,
      },
      popup = {
        relative = 'win',
        position = {
          row = '5%',
          col = '95%',
        },
        size = 30,
        border = {
          style = 'rounded',
          text = {
            top = ' Search ',
            top_align = 'left',
          },
        },
        win_options = {
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
        },
      },

      hooks = {
        before_mount = function(input)
          -- code
        end,
        after_mount = function(input)
          local opts = { buffer = input.bufnr }

          -- Esc goes to normal mode
          vim.keymap.set('i', '<Esc>', '<cmd>stopinsert<cr>', opts)

          -- Close the input in normal mode
          vim.keymap.set('n', '<C-c>', '<Plug>(searchbox-close)', opts)
          vim.keymap.set('n', '<Esc>', '<Plug>(searchbox-close)', opts)
        end,
        on_done = function(value, search_type)
          -- code
        end,
      },
    }
  end,
}
