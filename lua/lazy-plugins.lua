-- [[ Configure and install plugins ]]
--
--  Docs:
--    https://lazy.folke.io/spec
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- 🔒 Lockfile
-- After every update, the local lockfile (lazy-lock.json) is updated with the installed revisions. It is recommended to have this file under version control.
--
-- If you use your Neovim config on multiple machines, using the lockfile, you can ensure that the same version of every plugin is installed.
-- If you are on another machine, you can do `:Lazy restore`, to update all your plugins to the version from the lockfile.

local plugins = function()
  return {
    require 'plugins.colorscheme',

    -- PERF Lsp slow as fuck sometimes, but culprit might always be the server its self, but nonethe less everything should be async, so if the server is slowing the fuck down, what does it matter to us? that seems like a problem
    require 'plugins.lsp',

    require 'plugins.dap',

    -- PERF Might slow further test needed
    require 'plugins.indent-blankline',

    require 'plugins.snacks',

    -- PERF: Slow In bigfiles, treesitter has a slight slow when highlighting
    -- In cases like this regex based highglight is instant. Also inserting is majorly slow with treesitter, even if highlight is turned off.
    -- Update: I've found that is 'treesitter indent' that causes this huge slowness on insert
    -- Edit: `.ll` files from llvm is slow to <C-d> or <C-u> from the end (tested with a.ll)
    --     Disabling the highlight fix it
    -- Update: a.ll
    require 'plugins.treesitter',

    require 'plugins.nvim-treesitter-pairs',
    require 'plugins.telescope',
    require 'plugins.mini',
    require 'plugins.lualine',
    require 'plugins.conform',
    require 'plugins.Comment',
    require('plugins.' .. vim.g.self.file_tree), -- NOTE: Slower than nvim-tree but better git support and has box to edit things, and indication of changes and bulk rename and select,

    -- PERF: needs to test more, bigfiles might need to slow the update time
    require 'plugins.blink-cmp',

    -- PERF: slow but maybe fixable.
    -- require 'plugins.hlargs',

    require 'plugins.bufjump',
    require 'plugins.focus',
    require 'plugins.toggleterm',
    require 'plugins.scope',
    require 'plugins.which-key',
    require 'plugins.coerce',
    require 'plugins.diffview',
    require 'plugins.fzf-lua',
    require 'plugins.vim-matchup', -- NOTE: Interaction with matchup and treesitter slow thing down when jumping from one context to another(lua table to another with jk), I think longer lines are more problematic
    require 'plugins.autopairs',
    require 'plugins.move',
    require 'plugins.undotree',
    require 'plugins.guess-indent',

    -- PERF: Why is it mildly slow? findout maybe its all the stuff of autocommands
    require('plugins.' .. vim.g.self.session_plugin),

    require 'plugins.zen-mode',
    require 'plugins.harpoon',
    require 'plugins.oil',
    require 'plugins.yazi',
    require 'plugins.better-scape',
    require 'plugins.live-command',

    require 'plugins.colorizer',
    require 'plugins.dressing',

    true and require 'plugins.spider' or require 'plugins.neowords',
    require 'plugins.multiple-cursors',
    require 'plugins.improved-ft',
    (false and (vim.fn.has 'nvim-0.10' == 1 or vim.fn.has 'nvim-0.11' == 1)) and require 'plugins.dropbar' or require 'plugins.incline',
    require 'plugins.cycler',
    require 'plugins.marks', -- alternative: https://github.com/desdic/marlin.nvim
    require 'plugins.snap',

    require 'plugins.nvim-tree',
    require 'plugins.aerial',
    require 'plugins.compile-mode',
    require 'plugins.stickybuf',

    { 'tpope/vim-abolish', lazy = true },
    { 'tpope/vim-repeat', keys = { { '.' }, { ';' } } },

    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
  }
end

local unused_plugins = function()
  return {
    -- { 'tpope/vim-surround', lazy = false },
    -- NOTE :h event for valid  vim events, there are some only in neovim like LspDetach

    -- Another option https://github.com/Yggdroot/indentLine
    -- require 'plugins.indentmini', -- Despite what is says, it's slow
    -- require 'plugins.bigfile',

    { 'tpope/vim-sleuth', event = 'BufEnter', lazy = true, enabled = false }, -- Detect tabstop and shiftwidth automatically

    -- Color picker ccc
    { 'uga-rosa/ccc.nvim', enabled = false, cmds = { 'CccHighlighterToggle', 'CccPick', 'CccConvert' }, lazy = true, event = 'VeryLazy' },

    {
      'bfredl/nvim-incnormal',
      enabled = false,
      event = 'BufEnter',
    }, -- NOTE:live-command if better
    {
      'pteroctopus/faster.nvim',
      enabled = false,
      event = 'BufEnter',
    }, -- Faster j,k movement
    {
      'yorickpeterse/nvim-pqf',
      lazy = false,
      enabled = false,
    }, -- Nicer Quick List
    {
      'rktjmp/playtime.nvim',
      enabled = false,
    },

    {
      'filipdutescu/renamer.nvim',
      branch = 'master',
      enabled = false,
      lazy = false,
      event = 'LspAttch',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
      'folke/trouble.nvim',
      lazy = true,
      enabled = false,
    }, -- LPS Diagnostic with colors and shit
    {
      'iamcco/markdown-preview.nvim',
      lazy = false,
      enabled = false,
      build = 'cd app && npm install',
      config = function()
        vim.g.mkdp_filetypes = { 'markdown' }
      end,
      ft = { 'markdown' },
    },
    {
      'ekickx/clipboard-image.nvim',
      branch = 'feat_WSL',
      lazy = false,
      enabled = false,
    },
    {
      -- Investigate this further, why isnt it working
      'backdround/tabscope.nvim',
      event = 'VimEnter',
      lazy = false,
      enabled = false,
    },
    {
      'chrisgrieser/nvim-various-textobjs',
      --alternative: 'XXiaoA/ns-textobject.nvim'
      enabled = false,
      lazy = false,
      opts = { useDefaultKeymaps = true },
    },

    -- require 'plugins.tabby',
    -- require 'plugins.tabline',
    -- require 'plugins.wilder',

    require 'plugins.fine-cmdline',

    require 'plugins.codewindow',

    require 'plugins.neogit',

    require 'plugins.gitsigns',

    require 'plugins.git_conflict',

    require 'plugins.nvim-hlslens',
    --------------------------------------

    -- require 'plugins.telescope-debug',

    -- BUGGY: require 'plugins.autocomplete',
    -- BUGGY: require 'plugins.epo',

    require 'plugins.cmdbuf',
    require 'plugins.cmp',

    require 'plugins.todo-comments',

    --------------------------------------

    {
      'gennaro-tedesco/nvim-peekup',
      enabled = false --[[Mega Slow, plus :Telescope register is almost the same]],
      lazy = true,
    },
    -- Hop (Better Navigation)
    {
      'phaazon/hop.nvim',
      opts = {},
      lazy = true,
      enabled = false,
    },
    {
      'jinh0/eyeliner.nvim',
      lazy = true,
      enabled = false,
      config = function()
        require('eyeliner').setup {
          highlight_on_key = true, -- show highlights only after keypress
          dim = false, -- dim all other characters if set to true (recommended!)
        }
      end,
    },
    require 'plugins.inc-rename',
    require 'plugins.lint',

    -- require 'plugins.nnn', -- NOTE: works fine but needs better NNN configurations with tui-preview plugin ,
    -- require 'plugins.lf', -- NOTE: Appear to bugout with my toggleterm config
    require 'plugins.noice',

    -- @
    require 'plugins.neo-tree',
    -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    This is the easiest way to modularize your config.
    --
    --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
    -- { import = 'custom.plugins' },

    require 'plugins.bufmanager',

    require 'plugins.cybu', -- buffer cycle ? why tho

    require 'plugins.img-clip',
    -- require 'plugins.trailblazer', -- TODO : Make something simpler than this some other day
    require 'plugins.portal',
    require 'plugins.submode',

    require 'plugins.searchbox',

    require 'plugins.nvim-snippy',
    require 'plugins.tmux-file-jump',
    { 'michaeljsmith/vim-indent-object', lazy = true },
    { 'sakhnik/nvim-gdb', lazy = true },
    require 'plugins.text-case',
  }
end

local lazy_config = {
  defaults = { lazy = true },
  install = { colorscheme = { 'personal' } },
  change_detection = { notify = false },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.self.nerd_font and {
      ft = '',
      lazy = '󰂠',
      loaded = '',
      notloaded = '',
    } or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
  profiling = {
    -- Enables extra stats on the debug tab related to the loader cache.
    -- Additionally gathers stats about all package.loaders
    loader = false,

    -- Track each new require in the Lazy profiling tab
    require = true,
  },

  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'zip',
        'zipPlugin',
        'matchparen',
        '2html_plugin',
        'tohtml',
        'getscript',
        'getscriptPlugin',
        'logipat',
        'netrw',
        'netrwPlugin',
        'netrwSettings',
        'netrwFileHandlers',
        -- 'matchit',
        'tar',
        'tarPlugin',
        'rrhelper',
        'spellfile_plugin',
        'vimball',
        'vimballPlugin',
        'zip',
        'zipPlugin',
        'tutor',
        'rplugin',
        'syntax',
        'synmenu',
        'optwin',
        'compiler',
        'bugreport',
        'ftplugin',
      },
    },
  },
}

local personally_disable_runtime_plugins = function()
  for _, bplugin in ipairs(lazy_config.performance.rtp.disabled_plugins) do
    if true then
      break
    end
    vim.g['loaded_' .. bplugin:gsub('%..*', '')] = 1
  end
end

personally_disable_runtime_plugins()

-- NOTE: Where you install your plugins.
require('lazy').setup(plugins(), lazy_config)

require('plugins.local.huge-file').setup()
require('plugins.local.pattern-highlight').setup()

-- vim: ts=2 sts=2 sw=2 et
-- :set formatoptions-=r formatoptions-=c formatoptions-=o
