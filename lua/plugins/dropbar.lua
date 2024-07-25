local all_valid_types = {

  'array',
  'boolean',
  'break_statement',
  'call',
  'case_statement',
  'class',
  'constant',
  'constructor',
  'continue_statement',

  'delete',
  'do_statement',
  'enum',
  'enum_member',
  'event',

  'for_statement',
  'function',
  'h1_marker',

  'h2_marker',
  'h3_marker',
  'h4_marker',
  'h5_marker',
  'h6_marker',
  'if_statement',
  'interface',

  'keyword',
  'list',
  'macro',

  'method',
  'module',
  'namespace',
  'null',
  'number',
  'operator',
  'package',
  'pair',
  'property',
  'reference',
  'repeat',
  'scope',
  'specifier',
  'string',
  'struct',
  'switch_statement',
  'type',
  'type_parameter',
  'unit',
  'value',
  'variable',
  'while_statement',
  'declaration',
  'field',
  'identifier',
  'object',
  'statement',
  'text',
}

local using_valid_type = {
  'function',
  'namespace',
  'while_statement',
  'for_statement',
  'h1_marker',
  'h2_marker',
  'h3_marker',
  'h4_marker',
  'h5_marker',
  'h6_marker',
}

return {
  'Bekaboo/dropbar.nvim',
  -- optional, but required for fuzzy finder support
  lazy = false,
  opts = {
    sources = {
      treesitter = {
        valid_types = using_valid_type,
      },
    },
  },
  dependencies = {
    'nvim-telescope/telescope-fzf-native.nvim',
  },
}
