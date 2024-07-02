return {
  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help ibl`
  pin = true,
  main = 'ibl',
  -- version = 'v3.7.1',
  event = 'VimEnter',
  enable = true,
  -- event = 'User FilePost',
  opts = {

    indent = {
      char = '▏',
      -- char = '▏',
      -- char = '｜',
      -- char = '▕',

      repeat_linebreak = true,
    },
    scope = {
      -- char = '▏',
      char = '▏',
      -- char = '▕',
      -- char = '│',
      --                          • ``
      priority = 2048,
      show_start = os.getenv 'TMUX' == nil,
      show_end = false,
      include = { node_type = { lua = { 'return_statement', 'table_constructor' } } },
    },
    whitespace = { remove_blankline_trail = true },
    -- NOTE: Char Options = "│' '│' '▏' "▎"
    --                      Alternatives: ~
    --                        • left aligned solid
    --                          • `▏`
    --                          • `▎` (default)
    --                          • `▍`
    --                          • `▌`
    --                          • `▋`
    --                          • `▊`
    --                          • `▉`
    --                          • `█`
    --                        • center aligned solid
    --                          • `│`
    --                          • `┃`
    --                        • right aligned solid
    --                          • `▕`
    --                          • `▐`
    --                        • center aligned dashed
    --                          • `╎`
    --                          • `╏`
    --                          • `┆`
    --                          • `┇`
    --                          • `┊`
    --                          • `┋`
    --                        • center aligned double
    --                          • `║`
    debounce = 10,

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
    local hide_first_indent = false
    if hide_first_indent then
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    end
    require('ibl').setup(opts)
  end,
}
