return {
  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help ibl`
  pin = true,
  main = 'ibl',
  -- version = 'v3.7.1',
  event = 'VimEnter',
  --event = 'User FilePost',
  opts = {

    indent = { char = '▏' },
    scope = { char = '│' },
    --NOTE: options = "│' '│' '▏' "▎"
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
    local hooks = require 'ibl.hooks'
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    require('ibl').setup(opts)
  end,
}
