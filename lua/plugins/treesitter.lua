-- Highlight groups don't have priority. They just define the highlighting.
--
-- The priority is set from the syntax in case of legacy highlighting :help :syn-priority, or by the query pattern in case of treesitter :help treesitter-highlight-priority. So in your case, if you want to make type.java have a higher priority, you need to find the query where it is defined. Copy the query into your config and manually set a higher priority.
--
-- Read :help treesitter-query for more information.
-- Help pages for:
--
-- :syn-priority in syntax.txt
--
-- treesitter-highlight-priority in treesitter.txt
--
-- treesitter-query in treesitter.txt
local disable_function = function(lang)
  if true then
    return true
  end
  local buf_name = vim.fn.expand '%'
  if vim.bo.filetype == 'tmux' or lang == 'conf' or string.find(buf_name, 'tmux%-') then
    return true
  end
end

return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
  build = ':TSUpdate',
  -- event = { 'BufReadPost', 'BufNewFile' },
  event = { 'BufEnter' },
  dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
  opts = {
    highlight = {
      enable = true,
      disable = function(lang, bufnr) -- Disable in large buffers
        -- return lang == 'cpp' and vim.api.nvim_buf_line_count(bufnr) > 50000
        return vim.api.nvim_buf_line_count(bufnr) > 50000
      end,
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn',
        node_incremental = 'grn',
        scope_incremental = 'grc',
        node_decremental = 'grm',
      },
    },
    textobjects = {
      enable = true,
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = false,
        set_jumps = true,
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
    },
    -- vim-matchup config
    matchup = {
      enable = true, -- mandatory, false will disable the whole extension
      disable = { 'c', 'ruby' }, -- optional, list of language that will be disabled
      -- [options]
    },
    ensure_installed = { 'bash', 'c', 'python', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
    -- Autoinstall languages that are not installed
    auto_install = true,
    --XXX: Found out that putting these highlight options is laggy on long lines when the cursor is
    -- on the far right going up and down (j and k movement)
    -- highlight = {
    --   enable = true,
    --   -- disable = disable_function,
    --   -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --   --  If you are experiencing weird indenting issues, add the language to
    --   --  the list of additional_vim_regex_highlighting and disabled languages for indent.
    --   additional_vim_regex_highlighting = { 'ruby' },
    -- },
    indent = { enable = true, disable = { 'ruby' } },
  },
  config = function(_, opts)
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

    -- Prefer git instead of curl in order to improve connectivity in some environments
    require('nvim-treesitter.install').prefer_git = true
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup(opts)

    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

    vim.treesitter.language.register('c', '*.cl')
    vim.treesitter.language.register('c', '*.h')
    vim.treesitter.language.register('c', '.h')
    vim.treesitter.language.register('c', 'cl')
    -- local treesitter_parser_config = require('nvim-treesitter.parsers').get_parser_configs()
    -- treesitter_parser_config.templ = {
    --   install_info = {
    --     url = 'https://github.com/vrischmann/tree-sitter-templ.git',
    --     files = { 'src/parser.c', 'src/scanner.c' },
    --     branch = 'master',
    --   },
    -- }
    --
    -- vim.treesitter.language.register('templ', 'templ')
  end,
}
