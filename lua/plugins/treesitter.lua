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

local disable_treesitter_when = function(lang, bufnr)
  local fts = { 'bin', 'odin', 'tmux', 'llvm', 'conf' }
  for i, ft in ipairs(fts) do
    if vim.bo.filetype == ft then
      return true
    end
  end

  local buf_name = vim.api.nvim_buf_get_name(bufnr)

  if lang == 'conf' or string.find(buf_name, 'tmux%-') then
    return true
  end

  local info = vim.loop.fs_stat(buf_name)
  local file_size_permitted = (20 * 1024 * 1024)
  local is_large_file = vim.fn.getfsize(buf_name) > file_size_permitted
  local is_large_file = info and (info.size > (20 * 1024 * 1024))

  if is_large_file then
    return true
  end

  if vim.api.nvim_buf_line_count(bufnr) > 200 * 1000 then
    return true
  end

  return false
end

-- NOTE: custom parser -> https://github.com/nvim-treesitter/nvim-treesitter/issues/2241
return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },
  -- event = { 'BufEnter' },
  dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects', event = 'InsertEnter' },
  opts = {

    --XXX: Found out that putting these highlight options is laggy on long lines when the cursor is
    -- on the far right going up and down (j and k movement).
    -- EDIT(2024-jul-06): This is only true together with vim-matchup, which I have disabled some things that improved performance
    highlight = {
      enable = true,
      disable = disable_treesitter_when,
      -- additional_vim_regex_highlighting = { 'c' },
    },
    -- NOTE: Very slow to INSERT text on bigfiles
    indent = { enable = false, disable = { 'ruby' } },

    incremental_selection = {
      enable = false,
      keymaps = {
        init_selection = '<CR>',
        scope_incremental = '<CR>',
        node_incremental = '<TAB>',
        node_decremental = '<S-TAB>',
      },
      -- keymaps = {
      --   init_selection = 'gnn',
      --   node_incremental = 'grn',
      --   scope_incremental = 'grc',
      --   node_decremental = 'grm',
      -- },
    },
    textobjects = {
      enable = true,
      disable = disable_treesitter_when,
      select = {
        enable = true,
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        disable = disable_treesitter_when,
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
    ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
    -- Autoinstall languages that are not installed
    auto_install = true,

    ---------------------------------------------------------------------------------------------------------
    -- PLUGINS ----------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------------
    matchup = {
      disable = disable_treesitter_when,
      enable = true,
      include_match_words = false,
    },

    pairs = {
      enable = true,
      disable = disable_treesitter_when,
      highlight_pair_events = { 'CursorMoved' }, -- e.g. {"CursorMoved"}, -- when to highlight the pairs, use {} to deactivate highlighting
      highlight_self = true, -- whether to highlight also the part of the pair under cursor (or only the partner)
      goto_right_end = false, -- whether to go to the end of the right partner or the beginning
      -- fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')", -- What command to issue when we can't find a pair (e.g. "normal! %")
      -- fallback_cmd_normal = 'normal! %',
      fallback_cmd_normal = nil,
      keymaps = {
        -- goto_partner = '<leader>%',
        goto_partner = '%',
        delete_balanced = 'X',
      },
      delete_balanced = {
        only_on_first_char = false, -- whether to trigger balanced delete when on first character of a pair
        fallback_cmd_normal = nil, -- fallback command when no pair found, can be nil
        longest_partner = false, -- whether to delete the longest or the shortest pair when multiple found.
        -- E.g. whether to delete the angle bracket or whole tag in  <pair> </pair>
      },
    },
    ---------------------------------------------------------------------------------------------------------
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
    -- Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    -- Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    -- Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

    -------------------------------------------------------
    -----How to get parser from a new language-------------
    -------------------------------------------------------
    -- local treesitter_parser_config = require('nvim-treesitter.parsers').get_parser_configs()
    -- treesitter_parser_config.odin = {
    --   install_info = {
    --     url = 'https://github.com/ap29600/tree-sitter-odin',
    --     branch = 'main',
    --     files = { 'src/parser.c' },
    --   },
    --   filetype = 'odin',
    -- }
    -- vim.treesitter.language.register('odin', '*.odin')

    -- treesitter_parser_config.templ = {
    --   install_info = {
    --     url = 'https://github.com/vrischmann/tree-sitter-templ.git',
    --     files = { 'src/parser.c', 'src/scanner.c' },
    --     branch = 'master',
    --   },
    -- }
    --
    -- vim.treesitter.language.register('templ', 'templ')
    -------------------------------------------------------
    -------------------------------------------------------
  end,
}
