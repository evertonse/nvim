return {
  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help ibl`
  pin = true,
  main = 'ibl',
  version = 'v3.7.1',
  event = 'VimEnter',
  enable = true,
  -- event = 'User FilePost',
  opts = {

    indent = {
      -- char = '▏',
      -- char = '⏐',

      -- U+0007C ‭ |  GC=Sm SC=Common       VERTICAL LINE
      -- U+000A6 ‭ ¦  GC=So SC=Common       BROKEN BAR
      -- U+002C8 ‭ ˈ  GC=Lm SC=Common       MODIFIER LETTER VERTICAL LINE
      -- U+002CC ‭ ˌ  GC=Lm SC=Common       MODIFIER LETTER LOW VERTICAL LINE
      -- U+02016 ‭ ‖  GC=Po SC=Common       DOUBLE VERTICAL LINE
      -- U+023D0 ‭ ⏐  GC=So SC=Common       VERTICAL LINE EXTENSION
      -- U+02758 ‭ ❘  GC=So SC=Common       LIGHT VERTICAL BAR
      -- U+02759 ‭ ❙  GC=So SC=Common       MEDIUM VERTICAL BAR
      -- U+0275A ‭ ❚  GC=So SC=Common       HEAVY VERTICAL BAR
      -- U+02AF4 ‭ ⫴  GC=Sm SC=Common       TRIPLE VERTICAL BAR BINARY RELATION
      -- U+02AF5 ‭ ⫵  GC=Sm SC=Common       TRIPLE VERTICAL BAR WITH HORIZONTAL STROKE
      -- U+02AFC ‭ ⫼  GC=Sm SC=Common       LARGE TRIPLE VERTICAL BAR OPERATOR
      -- U+02AFE ‭ ⫾  GC=Sm SC=Common       WHITE VERTICAL BAR
      -- U+02AFF ‭ ⫿  GC=Sm SC=Common       N-ARY WHITE VERTICAL BAR
      -- U+0FF5C ‭ ｜ GC=Sm SC=Common       FULLWIDTH VERTICAL LINE
      -- U+0FFE4 ‭ ￤ GC=So SC=Common       FULLWIDTH BROKEN BAR
      -- char = '▏',
      char = '▏',
      -- char = '｜',
      -- char = '▕',

      repeat_linebreak = true,
    },
    scope = {
      char = '▏',
      -- char = ' ▏',
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
