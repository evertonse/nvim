local status_ok, hlargs = pcall(require, "hlargs")
if not status_ok then
  return
end

local vars = require "custom.user.vars"
local c = require("custom.user.colors." .. vars.theme)
-- require('hlargs').setup(); return --DEBUG with default
hlargs.setup {
  color = c.code.Parameter,
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
      python = { "self", "cls" },
      lua = { "self" },
      cpp = { "this" },
    },
    usages = {
      python = { "self", "cls" },
      lua = { "self" },
      cpp = { "this" },
    },
  },
  performance = {
    parse_delay = 0.25,
    slow_parse_delay = 155,
    max_iterations = 1000,
    max_concurrent_partial_parses = 500,
    debounce = {
      partial_parse = 5,
      partial_insert_mode = 100,
      total_parse = 700,
      slow_parse = 5000,
    },
  },
}
-- (You may omit the settings whose defaults you're ok with)
