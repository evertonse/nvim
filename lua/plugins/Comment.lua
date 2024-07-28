local comment_line_prefix = 'gc'
local comment_block_prefix = 'gb'
return {
  'numToStr/Comment.nvim',
  lazy = false,
  opts = {
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil,
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
      ---Line-comment toggle keymap
      line = comment_line_prefix,
      ---Block-comment toggle keymap
      block = comment_block_prefix,
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
      ---Line-comment keymap
      line = comment_line_prefix,
      ---Block-comment keymap
      block = comment_block_prefix,
    },
    ---LHS of extra mappings
    extra = {
      ---Add comment on the line above
      above = 'gcO',
      ---Add comment on the line below
      below = 'gco',
      ---Add comment at the end of line
      eol = 'gcA',
    },
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
      ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
      basic = true,
      ---Extra mapping; `gco`, `gcO`, `gcA`
      extra = true,
    },
    ---Function to call before (un)comment
    pre_hook = nil,
    ---Function to call after (un)comment
    post_hook = nil,
  },
  config = function(_, opts)
    local api = require 'Comment.api'
    local config = require('Comment.config'):get()

    require('Comment').setup(opts)

    vim.keymap.set('x', 'gc', function()
      local mode = vim.fn.mode()
      print(mode)
      local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)

      vim.api.nvim_feedkeys(esc, 'nx', false)
      if mode == 'V' or mode == 'n' then
        api.toggle.linewise(vim.fn.visualmode())
      elseif mode == 'v' or mode == '<C-v>' or mode == '<C-q>' then
        api.toggle.blockwise(vim.fn.visualmode())
      end
    end, { noremap = true, silent = true })
  end,
}
