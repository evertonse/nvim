-- [[ Configure and install plugins ]]
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
--
-- If you are on another machine, you can do `:Lazy restore`, to update all your plugins to the version from the lockfile.
SPEED_TEST = false

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
    require = false,
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
require('lazy').setup({

  -- NOTE :h event for valid  vim events, there are some only in neovim like LspDetach
  { 'uga-rosa/ccc.nvim', cmd = { 'CccHighlighterToggle', 'CccPick', 'CccConvert' }, lazy = false, event = 'VeryLazy' },
  { 'bfredl/nvim-incnormal', enabled = true, event = 'BufEnter' }, -- NOTE:live-command if better
  { 'moll/vim-bbye', lazy = false, enabled = true },
  { 'pteroctopus/faster.nvim', enabled = true, event = 'BufEnter' }, -- Faster j,k movement
  { 'yorickpeterse/nvim-pqf', lazy = false, enabled = false }, -- Nicer Quick List
  { 'rktjmp/playtime.nvim', enabled = false },
  require 'plugins.focus',
  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})
  -- "gc" to comment visual regions/lines
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

  require 'plugins.coerce',
  require 'plugins.Comment',
  {},
  -- require 'plugins.tabby',
  -- require 'plugins.tabline',
  -- require 'plugins.wilder',
  require 'plugins.fine-cmdline',

  require 'plugins.codewindow',

  require 'plugins.neogit',

  require 'plugins.gitsigns',

  require 'plugins.git_conflict',

  require 'plugins.diffview',

  require 'plugins.nvim-hlslens',
  --------------------------------------

  require 'plugins.which-key',

  require 'plugins.telescope',
  require 'plugins.fzf-lua',
  -- require 'plugins.telescope-debug',

  -- BUGGY: require 'plugins.autocomplete',
  -- BUGGY: require 'plugins.epo',

  require 'plugins.cmp',
  require 'plugins.blink-cmp',

  require 'plugins.conform',

  require 'plugins.colorscheme',

  require 'plugins.todo-comments',

  require 'plugins.toggleterm',

  require 'plugins.mini',

  require 'plugins.treesitter',
  require 'plugins.nvim-treesitter-pairs',
  -- require 'plugins.nvim-tree-pairs',
  require 'plugins.vim-matchup', -- NOTE: Interaction with matchup and treesitter slow thing down when jumping from one context to another(lua table to another with jk), I think longer lines are more problematic
  require 'plugins.autopairs',

  require 'plugins.dap',

  --------------------------------------

  require 'plugins.move',

  require 'plugins.bufjump',

  require 'plugins.undotree',
  {
    'gennaro-tedesco/nvim-peekup',
    enabled = false --[[Mega Slow, plus :Telescope register is almost the same]],
    lazy = false,
  },
  -- Hop (Better Navigation)
  {
    'phaazon/hop.nvim',
    opts = {},
    lazy = false,
    enabled = false,
  },
  {
    'jinh0/eyeliner.nvim',
    lazy = false,
    enabled = false,
    config = function()
      require('eyeliner').setup {
        highlight_on_key = true, -- show highlights only after keypress
        dim = false, -- dim all other characters if set to true (recommended!)
      }
    end,
  },
  require 'plugins.inc-rename',
  require 'plugins.harpoon',
  require 'plugins.dressing',
  require 'plugins.indent-blankline',
  require 'plugins.lint',

  require 'plugins.oil',
  require('plugins.' .. vim.g.self.file_tree), -- NOTE: Slower than nvim-tree but better git support and has box to edit things, and indication of changes and bulk rename and select,
  require 'plugins.yazi',
  -- require 'plugins.nnn', -- NOTE: works fine but needs better NNN configurations with tui-preview plugin ,
  -- require 'plugins.lf', -- NOTE: Appear to bugout with my toggleterm config
  require 'plugins.colorizer',
  require 'plugins.better-scape',
  require 'plugins.noice',
  require 'plugins.live-command',

  require 'plugins.guess-indent',
  { 'tpope/vim-sleuth', lazy = false, enabled = true }, -- Detect tabstop and shiftwidth automatically
  -- -- :set formatoptions-=r formatoptions-=c formatoptions-=o
  require 'plugins.scope',
  require('plugins.' .. vim.g.self.session_plugin),

  require 'plugins.neo-tree',
  require 'plugins.nvim-tree',
  require 'plugins.aerial',
  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
  true and require 'plugins.spider' or require 'plugins.neowords',
  require 'plugins.multiple-cursors',
  require 'plugins.improved-ft',
  (false and vim.fn.has 'nvim-0.10' == 1) and require 'plugins.dropbar' or require 'plugins.incline',
  require 'plugins.cycler',
  require 'plugins.snap',
  require 'plugins.bufmanager',
  require 'plugins.cybu',
  require 'plugins.img-clip',
  require 'plugins.marks', -- alternative: https://github.com/desdic/marlin.nvim
  -- require 'plugins.trailblazer', -- TODO : Make something simpler than this some other day
  require 'plugins.portal',
  require 'plugins.submode',
  require 'plugins.cmdbuf',
  require 'plugins.compile-mode',
  require 'plugins.searchbox',
  require 'plugins.stickybuf',
  require 'plugins.lsp',
  require 'plugins.nvim-snippy',
  require 'plugins.tmux-file-jump',
  require 'plugins.zen-mode',
  { 'sakhnik/nvim-gdb', lazy = false },
  { 'michaeljsmith/vim-indent-object', lazy = false },
  'nvim-lua/plenary.nvim',
  'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
  'MunifTanjim/nui.nvim',
  { 'tpope/vim-abolish', lazy = false },
  require 'plugins.text-case',
}, lazy_config)

-- vim: ts=2 sts=2 sw=2 et
