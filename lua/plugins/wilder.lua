return {
  --     u/roku_remote avatar
  -- roku_remote
  -- •
  -- 1y ago
  -- •
  -- Edited 1y ago
  -- #2 is one of my most desired features and, imo, one of Vim’s largest deficiencies. The command window doesn’t allow for incremental preview and command mode requires the use chords instead of vim’s language. I’ve only used it a little bit but I really like Emacs’ notion of the command line as a buffer like any other. Ideally, the command line should just be the current line of the command window, allowing for incremental preview and the usage of vim bindings, but allowing you to expand it to see the entire command history if desired. I imagine it would require MASSIVE changes, if the incremental preview feature could be ported to “normal” buffers at all
  'gelguy/wilder.nvim',
  lazy = false,
  enabled = vim.g.user.wilder, -- Using remote plugins which make a bit harder to configure, not good
  opts = { modes = { ':', '/', '?' } },
  config = function(_, opts)
    local wilder = require 'wilder'
    wilder.setup(opts)
    vim.o.wildmenu = true
  end,
}
