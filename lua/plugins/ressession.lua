return {
  'stevearc/resession.nvim',
  lazy = false,
  dependencies = {
    {
      'tiagovla/scope.nvim',
      lazy = false,
      config = true,
    },
  },
  opts = {
    -- override default filter
    buf_filter = function(bufnr)
      local buftype = vim.bo[bufnr].buftype
      if buftype == 'help' then
        return true
      end
      if buftype ~= '' and buftype ~= 'acwrite' then
        return false
      end
      if vim.api.nvim_buf_get_name(bufnr) == '' then
        return false
      end

      -- this is required, since the default filter skips nobuflisted buffers
      return true
    end,
    extensions = { scope = {} }, -- add scope.nvim extension
  },
  config = function(_, opts)
    local resession = require 'resession'
    resession.setup(opts)
    -- Resession does NOTHING automagically, so we have to set up some keymaps
    vim.keymap.set('n', '<leader>rss', resession.save)
    vim.keymap.set('n', '<leader>rsl', resession.load)
    vim.keymap.set('n', '<leader>rsd', resession.delete)
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 then
          -- Save these to a different directory, so our manual sessions don't get polluted
          resession.load(vim.fn.getcwd(), { dir = 'dirsession', silence_errors = true })
          vim.cmd [[stopinsert]]
        end
      end,
      nested = true,
    })
    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        resession.save(vim.fn.getcwd(), { dir = 'dirsession', notify = false })
      end,
    })
  end,
}
