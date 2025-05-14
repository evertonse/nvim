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
  lazy = true,
  event = 'BufReadPost',

  enabled = true,
  opts = {
    sources = {
      treesitter = {
        valid_types = using_valid_type,
      },
      path = {
        ---@type string|fun(buf: integer, win: integer): string
        relative_to = function(_, win)
          -- Workaround for Vim:E5002: Cannot find window number
          local ok, cwd = pcall(vim.fn.getcwd, win)
          return ok and cwd or vim.fn.getcwd()
        end,
        ---Can be used to filter out files or directories
        ---based on their name
        ---@type fun(name: string): boolean
        filter = function(_)
          return true
        end,
        ---Last symbol from path source when current buf is modified
        ---@param sym dropbar_symbol_t
        ---@return dropbar_symbol_t
        modified = function(sym)
          return sym
        end,
        ---@type boolean|fun(path: string): boolean?|nil
        preview = function(path)
          local stat = vim.uv.fs_stat(path)
          if not stat or stat.type ~= 'file' then
            return false
          end
          if stat.size > 524288 then
            vim.notify(string.format('[dropbar.nvim] file "%s" too large to preview', path), vim.log.levels.WARN)
            return false
          end
          return true
        end,
      },
    },
  },
  dependencies = {
    'nvim-telescope/telescope-fzf-native.nvim',
  },
}
