return { 'lukas-reineke/indent-blankline.nvim', lazy = false, main = 'ibl', opts = {} }
  or { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    lazy = false,
    -- version = 'v3.7.1',
    -- event = 'BufEnter',
    --event = 'User FilePost',
    indent = { char = '│', highlight = { 'IblChar' } },
    scope = { char = '│', highlight = { 'IblScopeChar' } },
    -- whitespace = { highlight = { 'Whitespace', 'NonText' } },
    opts = {

      --char = "│"
      --char = "▏"
      --char = "▎"
      indent = { char = '│' },
      scope = { char = '│' },
      exclude = {
        filetypes = {
          'help',
          'terminal',
          'lazy',
          'lspinfo',
          'mason',
          'startify',
          'dashboard',
          'packer',
          'neogitstatus',
          'NvimTree',
          'Trouble',
          'TelescopePrompt',
          'TelescopeResults',
          'nvdash',
          'nvcheatsheet',
          'cmp_menu',
          '',
        },
        buftypes = { 'terminal', 'nofile', 'quickfix' },
      },
    },
    config = function(_, opts)
      -- local hooks = require 'ibl.hooks'
      -- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require('ibl').setup(opts)
    end,
  }
