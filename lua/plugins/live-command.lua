-- reddit: https://www.reddit.com/r/neovim/comments/xx5hhp/introducing_livecommandnvim_preview_the_norm/
return {
  'smjonas/live-command.nvim',
  -- live-command supports semantic versioning via tags
  -- tag = "1.*",
  config = function()
    require('live-command').setup {
      commands = {
        Norm = { cmd = 'norm' },
      },
    }
  end,
}
