return { --https://github.com/andymass/vim-matchup
  'andymass/vim-matchup',
  lazy = false,
  enabled = true,
  config = function()
    -- may set any options here
    vim.g.matchup_matchparen_offscreen = { method = 'popup' }
  end,
}
