return {
  'evertonse/cycler.nvim',
  lazy = true,
  event = 'BufReadPost',
  config = function()
    require('cycler').setup {
      cycles = vim.g.self.cycles,
    }

    vim.keymap.set({ 'v', 'n' }, '<C-x>', function()
      require('cycler').cycle()
    end)
  end,
}
