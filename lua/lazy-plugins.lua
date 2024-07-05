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

local lazy_config = {
  defaults = { lazy = true },
  install = { colorscheme = { 'personal' } },
  change_detection = { notify = true },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.user.nerd_font and {
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
        '2html_plugin',
        'tohtml',
        'getscript',
        'getscriptPlugin',
        'gzip',
        'logipat',
        'netrw',
        'netrwPlugin',
        'netrwSettings',
        'netrwFileHandlers',
        'matchit',
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
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- :h event for valid  vim events, there are some only in neovim like LspDetach
  { 'tpope/vim-sleuth', lazy = false, enabled = false }, -- Detect tabstop and shiftwidth automatically
  { 'moll/vim-bbye', event = 'User FileOpened' },
  { 'yorickpeterse/nvim-pqf', enabled = false }, -- Nicer Quick List

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  require 'plugins.Comment',
  --{ 'nvim-tree/nvim-web-devicons' },
  { 'moll/vim-bbye', lazy = false },
  -- lazy.nvim
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
  -- require 'plugins.tabby',
  {
    'kdheepak/tabline.nvim',
    lazy = false,
    enabled = false,
  },
  {
    'tiagovla/scope.nvim',
    config = function()
      require('scope').setup {}
    end,
    lazy = false,
    -- event = 'VeryLazy',
    enabled = true,
  },
  require 'plugins.tabline',

  require 'plugins.wilder',

  require 'plugins.fine-cmdline',

  require 'plugins.neogit',

  require 'plugins.gitsigns',

  require 'plugins.git_conflict',

  { 'sindrets/diffview.nvim', lazy = false },

  require 'plugins.which-key',

  require 'plugins.telescope',

  require 'plugins.lspconfig',

  require 'plugins.conform',

  require 'plugins.cmp',

  require 'plugins.colorscheme',

  require 'plugins.todo-comments',

  require 'plugins.toggleterm',

  require 'plugins.mini',

  require 'plugins.treesitter',

  require 'plugins.debug',

  ------------------------

  {
    'mbbill/undotree',
    enabled = true,
    lazy = false,
    key = { {
      'n',
      '<leader><F5>',
      function()
        vim.cmd [[UndotreeToggle]]
      end,
    } },
  },
  {
    'gennaro-tedesco/nvim-peekup',
    enabled = false --[[Mega Slow, plus :Telescope register is almost the same]],
    lazy = false,
  },
  require 'plugins.inc-rename',
  require 'plugins.harpoon',
  require 'plugins.vim_matchup',
  require 'plugins.indent_blankline',
  require 'plugins.lint',
  require 'plugins.autopairs',

  require 'plugins.oil',
  require 'plugins.neo-tree', -- NOTE: Slower than nvim-tree but better git support and has box to edit things, and indication of changes and bulk rename and select,
  -- require 'plugins.nnn', -- NOTE: works fine but needs better NNN configurations with tui-preview plugin ,
  -- require 'plugins.lf', -- NOTE: Appear to bugout with my toggleterm config
  require 'plugins.colorizer',
  require 'plugins.better-scape',
  require 'plugins.noice',
  { 'bfredl/nvim-incnormal', enabled = false, event = 'BufEnter' }, -- NOTE:live-command if better
  require 'plugins.live-command',

  require 'plugins.guess-indent',
  -- Eiter we use persistence or auto-session, based on user config
  require ('plugins.' .. vim.g.user.session_plugin),
  require 'plugins.alternate-toggle',
  { 'pteroctopus/faster.nvim', enabled = false, event = 'BufEnter' }, -- Faster j,k movement
  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
}, lazy_config)

-- vim: ts=2 sts=2 sw=2 et
