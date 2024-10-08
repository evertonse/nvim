-- local status_ok, nvim_tree = pcall(require, "nvim-tree")
-- if not status_ok then
--   return
-- end
-- local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
-- if not config_status_ok then
--   return
-- end

local M = {}

vim.treesitter.language.register('c', 'cl') -- the .cl filetype will use the c parser and queries.
M.treesitter = {
  matchup = {
    enable = false, -- mandatory, false will disable the whole extension
    -- disable = { "c", "ruby" }, -- optional, list of language that will be disabled
    -- [options]
  },
  -- run = ':TSPUpdate',
  ensure_installed = {
    'bash',
    'html',
    'javascript',
    'json',
    'lua',
    'markdown',
    'python',
    'query',
    'regex',
    'tsx',
    'typescript',
    'vim',
    'yaml',
    'c',
    'cpp',
    'vimdoc',
    -- --"typescript", "toml","tsx", "css",
    'rust',
    'java',
    'markdown_inline',
  }, -- one of "all" or a list of languages
  sync_install = true,
  auto_install = true,
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    use_languagetree = true,
    disable = {}, -- list of language that will be disabled
    additional_vim_regex_highlighting = false,
    custom_captures = {},
  },

  autopairs = {
    enable = true,
  },

  indent = { enable = true, disable = {} },
  markid = { enable = true },

  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { 'BufWrite', 'CursorHold' },
  },

  illuminate = {
    enable = true,
    loaded = false,
  },

  incremental_selection = {
    enable = true,
    disable = {},
    keymaps = {
      init_selection = 'gis',
      scope_incremental = 'gsi',
      node_incremental = 'gni',
      node_decremental = 'gnd',
    },
  },

  context_commentstring = {
    enable = true,
  },

  playground = {
    enable = true,
    disable = {},
    updatetime = 250, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>sn'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>sN'] = '@parameter.inner',
      },
    },
  },
}

M.align = {
  init = function()
    local NS = { noremap = true, silent = true }

    -- Aligns to 1 character
    vim.keymap.set('x', '<leader>aa', function()
      require('align').align_to_char {
        length = 1,
      }
    end, NS)

    -- Aligns to 2 characters with previews
    vim.keymap.set('x', '<leader>ad', function()
      require('align').align_to_char {
        preview = true,
        length = 2,
      }
    end, NS)

    -- Aligns to a string with previews
    vim.keymap.set('x', '<leader>aw', function()
      require('align').align_to_string {
        preview = true,
        regex = false,
      }
    end, NS)

    -- Aligns to a Vim regex with previews
    vim.keymap.set('x', '<leader>ar', function()
      require('align').align_to_string {
        preview = true,
        regex = true,
      }
    end, NS)

    -- Example gawip to align a paragraph to a string with previews
    vim.keymap.set('n', '<leader>gaw', function()
      local a = require 'align'
      a.operator(a.align_to_string, {
        regex = false,
        preview = true,
      })
    end, NS)

    -- Example gaaip to align a paragraph to 1 character
    vim.keymap.set('n', '<leader>gaa', function()
      local a = require 'align'
      a.operator(a.align_to_char)
    end, NS)
  end,
}

M.todo = {
  opts = {
    search = {
      command = 'rg',
      args = {
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
      },
      -- regex that will be used to match keywords.
      -- don't replace the (KEYWORDS) placeholder
      -- pattern = [[\b(KEYWORDS).*:]], -- ripgrep regex

      -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
    },
    keywords = {
      TODO = { icon = ' ', color = 'warn' },
      NOTE = { icon = '> ', color = 'hint', alt = { 'INFO', '@important' } },
      TEST = {
        icon = ' ' --[[ ⏲  ]],
        color = 'test',
        alt = { 'DONE', 'TESTING', 'PASSED', 'FAILED' },
      },
    },
    colors = {
      warn = { 'DiagnosticWarn' },
      info = { 'DiagnosticInfo' },
      hint = { 'DiagnosticHint' },
    },
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    highlight = {
      multiline = true, -- enable multine todo comments
      multiline_pattern = '^.', -- lua pattern to match the next multiline from the start of the matched keyword
      multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
      before = '', -- "fg" or "bg" or empty
      keyword = 'wide', -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
      after = 'fg', -- "fg" or "bg" or empty
      --TODO: all :good
      -- pattern = [[.*<(KEYWORDS\s*:)]], -- pattern or table of patterns, used for highlighting (vim regex)
      comments_only = true, -- uses treesitter to match keywords in comments only
      max_line_len = 400, -- ignore lines longer than this
      exclude = {}, -- list of file types to exclude highlighting
    },
  },
}

M.mason = {
  config = function()
    require('mason').setup {
      ensure_installed = {
        -- lua stuff
        'lua-language-server',
        'stylua',
        'autoflake',
        'bash-language-server',
        'html-lsp',
        'jdtls',
        'lua-language-server',
        'opencl-language-server',
        'rust-analyzer',

        -- web dev stuff
        'css-lsp',
        'html-lsp',
        'typescript-language-server',
        'bash-language-server',
        'deno',
        'prettier',

        -- c/cpp stuff
        'clangd',
        'clang-format',

        -- python

        'black',
        'flake8',
        'debugpy',
        'pylyzer',
        'mypy',
        'pyright',
        'pylsp',
      },
      automatic_installation = true,
    }
  end,
}

M.blankline = {
  indentLine_enabled = 1,
  use_treesitter = true,
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  show_current_context = true,
  show_current_context_start = true,
  context_char = '│',
  max_indent_increase = 1,
  context_patterns = {
    'class',
    'return',
    'function',
    'fn',
    'func',
    'def',
    'method',
    'if',
    'while',
    'jsx_element',
    'for',
    '^object',
    '^table',
    'block',
    -- "arguments",
    -- "if_statement",
    -- "else_clause",
    -- "jsx_element",
    -- "jsx_self_closing_element",
    -- "try_statement",
    -- "catch_clause",
    -- "import_statement",
    -- "operation_type",
  },

  disable_warning_message = true,
}

return M
