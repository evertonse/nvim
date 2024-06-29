return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    event = 'User FilePost',
    opts = {

      --char = "│"
      --char = "▏"
      --char = "▎"
      indent = { char = '│' },
      scope = { char = '│' },
      exclude = {
        filetype = {
          'help',
          'terminal',
          'lazy',
          'lspinfo',
          'TelescopePrompt',
          'TelescopeResults',
          'mason',
          'nvdash',
          'nvcheatsheet',
          'startify',
          'dashboard',
          'packer',
          'neogitstatus',
          'NvimTree',
          'Trouble',
          'help',
          'lazy',
          'lspinfo',
          'TelescopePrompt',
          'TelescopeResults',
          'nvdash',
          'nvcheatsheet',
          'cmp_menu',
          '',
        },
        buftype_ = { 'terminal', 'nofile', 'quickfix' },
      },

      config = function(_, opts)
        local hooks = require 'ibl.hooks'
        hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
        require('ibl').setup(opts)
      end,
    },
  },
}
