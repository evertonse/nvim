return {
  'm-demare/hlargs.nvim',
  lazy = false,
  enabled = true,
  opts = {
    color = '#909090',
    highlight = {},
    excluded_filetypes = {},
    paint_arg_declarations = true,
    paint_arg_usages = true,
    paint_catch_blocks = {
      declarations = true,
      usages = true,
    },
    extras = {
      named_parameters = true,
    },
    hl_priority = 10000,
    excluded_argnames = {
      declarations = {
        python = { 'self', 'cls' },
        lua = { 'self' },
        cpp = { 'this' },
      },
      usages = {
        python = { 'self', 'cls' },
        lua = { 'self' },
        cpp = { 'this' },
      },
    },
    performance = {
      parse_delay = 1,
      slow_parse_delay = 10,
      max_iterations = 200,
      max_concurrent_partial_parses = 30,
      debounce = {
        partial_parse = 3,
        partial_insert_mode = 100,
        total_parse = 700,
        slow_parse = 5000,
      },
    },
  },
  config = function()
    require 'custom.plugins.configs.hlargs'
    require('hlargs').enable()
  end,
}
