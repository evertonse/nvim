---@type LazySpec
return {
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  -- docs: https://yazi-rs.github.io/docs/quick-start/

  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      '<leader>-',
      function()
        require('yazi').yazi()
      end,
      desc = 'Open the file manager',
    },
    {
      -- Open in the current working directory
      '<leader>_',
      function()
        require('yazi').yazi(nil, vim.fn.getcwd())
      end,
      desc = "Open the file manager in nvim's working directory",
    },
  },

  ---@type YaziConfig
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
  },
}
