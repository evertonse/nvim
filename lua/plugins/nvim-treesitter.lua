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

local disable_treesitter_when = require('functions').disable_treesitter_highlight_when

local enabled = true
-- NOTE: custom parser -> https://github.com/nvim-treesitter/nvim-treesitter/issues/2241
return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
  build = ':TSUpdate',
  event = { 'VimEnter' },
  lazy = false,
  enabled = enabled,
  dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects', enabled = enabled },
  opts = {
    sync_install = false,

    --XXX: Found out that putting these highlight options is laggy on long lines when the cursor is
    -- on the far right going up and down (j and k movement).
    -- EDIT(2024-jul-06): This is only true together with vim-matchup, which I have disabled some things that improved performance
    --- EDIT 2025-05-18: I wanna do things and these theesitter modules gets in the way
    ---                  The highlight module doesnt do much on neovim-0.11 it just setup's up some filetype autocmmands and do vim.tresitter.start(bufnr, lang) when a ft is detected
    ---                  We're gonna do this ourselves because sometimes I wanna be very precise about when do I enable TShighlight and do some heuristics to decide when to enable regex highlight. Sometimes I wanna do from BufReadPre, wayy before ft gets even decided. And nvim-treesitter keeps getting in the way by chaging something I did before
    ---                  Because of that, at least the highlight, we can setup ourselves. So i'm setting to false here.
    highlight = {
      enable = false,
    },
    -- NOTE: Very slow to INSERT text on bigfiles
    indent = { enable = false, disable = { 'ruby' } },

    incremental_selection = {
      enable = false,
      disable = disable_treesitter_when,
      keymaps = {
        init_selection = '<CR>',
        scope_incremental = '<CR>',
        node_incremental = '<CR>',
        node_decremental = '<S-<CR>>',
      },
      -- keymaps = {
      --   init_selection = 'gnn',
      --   node_incremental = 'grn',
      --   scope_incremental = 'grc',
      --   node_decremental = 'grm',
      -- },
    },
    textobjects = {
      enable = enabled,
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
    ensure_installed = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
    },
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
    local ts_configs = require 'nvim-treesitter.configs'
    ts_configs.setup(opts)

    --- NOTE: 'nvim-treesitter' dos set some default language registrations,
    ---       So we set those we want AFTER nvim-treesitter.configs.setup
    --- NOTE: Sometimes, even if we set right here, still get either ovewritten or fucked somewhere in FileType events bizarro, even tho I've checked by modified the nvim-treesitter plugin itsself, the order IS/WAS correct
    ---       So if something you go to any.lua and here to check things
    if vim.g.self and vim.g.self.treesitter_registrations then
      for lang, fts in pairs(vim.g.self.treesitter_registrations) do
        assert(lang ~= nil and fts ~= nil)
        -- print(vim.inspect { lang, fts })
        vim.treesitter.language.register(lang, fts)
      end
    else
      vim.notify 'Missing vim.g.self.treesitter_registrations'
    end
  end,
}
