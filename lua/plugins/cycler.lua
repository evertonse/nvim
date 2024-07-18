return {
  'evertonse/cycler.nvim', --NOTE: Maybe instead of alternater we want CYCLER
  lazy = true,
  event = 'BufReadPost',
  config = function()
    require('cycler').setup {
      cycles = vim.g.self.cycles,
    }

    vim.keymap.set(
      'n',
      '<C-x>', -- <space><space>
      function()
        require('cycler').cycle()
      end
    )
  end,
}
