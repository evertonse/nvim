return { --https://github.com/andymass/vim-matchup
  'andymass/vim-matchup',
  event = 'BufEnter',
  enabled = true,
  config = function()
    -- PERFORMANCE: CHECK MatchupShowTimes

    vim.g.matchup_matchparen_offscreen = {}
    -- vim.g.matchup_matchparen_offscreen = { method = 'status' }
    -- vim.g.matchup_matchparen_offscreen = { method = 'popup' }

    -- Lower the highlighting timeouts. Note that if highlighting takes longer than the timeout, highlighting will not be attempted again until the cursor moves.
    vim.g.matchup_matchparen_timeout = 130 -- Decrease timeout for matching

    vim.g.matchup_matchparen_insert_timeout = 40

    -- Deferred highlighting improves cursor movement performance (for example, when using hjkl) by delaying highlighting for a short time and waiting to see if the cursor continues moving
    vim.g.matchup_matchparen_deferred = 1

    vim.g.matchup_matchparen_deferred_show_delay = 50

    vim.g.matchup_matchparen_deferred_hide_delay = 700

    vim.g.matchup_matchparen_hi_surround_always = 0 -- Disable surround highlighting

    vim.g.matchup_disable_virtual_text = 1

    -- NOTE: Lags a lot with treesitter highlighting IDK WHY
    vim.g.matchup_matchparen_enabled = 1

    vim.g.matchup_surround_enabled = 1 -- Surround motions

    vim.g.matchup_motion_enabled = 1

    vim.g.matchup_text_obj_enabled = 1

    vim.g.matchup_delim_noskips = 0 -- " recognize symbols within comments and within string
    -- vim.g.matchup_delim_noskips = 1 -- " recognize symbols within comments
    -- vim.g.matchup_delim_noskips = 2 -- " don't recognize anything in comments

    -- To configure the number of lines to search in either direction while using motions and text objects.
    -- Does not apply to match highlighting (see g:matchup_matchparen_stopline instead).
    vim.g.matchup_delim_stopline = 1500

    -- Matching does not work when lines are too far apart.
    -- The number of search lines is limited for performance reasons. You may increase the limits with the following options:
    vim.g.matchup_matchparen_stopline = 1

    -- Customize like below in https://github.com/andymass/vim-matchup/wiki/The-match-up-wiki
    vim.cmd [[
      autocmd FileType lua let b:match_words = 'for:end'
    ]]
  end,
}
