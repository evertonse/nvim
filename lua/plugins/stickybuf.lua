return {
  'stevearc/stickybuf.nvim',
  lazy = false,
  opts = {},
  config = function(_, opts)
    require('stickybuf').setup {
      -- This function is run on BufEnter to determine pinning should be activated
      get_auto_pin = function(bufnr)
        -- You can return "bufnr", "buftype", "filetype", or a custom function to set how the window will be pinned.
        -- You can instead return an table that will be passed in as "opts" to `stickybuf.pin`.
        -- The function below encompasses the default logic. Inspect the source to see what it does.
        return require('stickybuf').should_auto_pin(bufnr)
      end,
    }

    vim.api.nvim_create_autocmd('BufEnter', {
      desc = 'Pin the buffer to any window that is fixed width or height',
      callback = function(args)
        local stickybuf = require 'stickybuf'
        if not stickybuf.is_pinned() and (vim.wo.winfixwidth or vim.wo.winfixheight) then
          stickybuf.pin()
        end
      end,
    })
  end,
}
