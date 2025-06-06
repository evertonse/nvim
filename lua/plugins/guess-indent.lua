-- This is the default configuration
return {
  'NMAC427/guess-indent.nvim',
  lazy = true,
  event = 'BufEnter',
  opts = {
    auto_cmd = true, -- Set to false to disable automatic execution
    override_editorconfig = true, -- Set to true to override settings set by .editorconfig
    filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
      'netrw',
      'tutor',
    },
    buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
      'help',
      'nofile',
      'terminal',
      'prompt',
    },
  },
  config = function(_, opts)
    require('guess-indent').setup(opts)
  end,
}
