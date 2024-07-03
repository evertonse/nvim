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
      lazy = '󰂠 ',
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
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  { 'pteroctopus/faster.nvim', enabled = false, event = 'BufEnter' }, -- Faster j,k movement
  { 'moll/vim-bbye', event = 'User FileOpened' },
  { 'yorickpeterse/nvim-pqf', enabled = false }, -- Nicer Quick List
  {
    'smjonas/inc-rename.nvim',
    lazy = false,
    config = function()
      require('inc_rename').setup {
        -- the name of the command
        cmd_name = 'IncRename',
        -- the highlight group used for highlighting the identifier's new name
        hl_group = 'Substitute',
        -- whether an empty new name should be previewed; if false the command preview will be cancelled instead
        preview_empty_name = false,
        -- whether to display a `Renamed m instances in n files` message after a rename operation
        show_message = true,
        -- whether to save the "IncRename" command in the commandline history (set to false to prevent issues with
        -- navigating to older entries that may arise due to the behavior of command preview)
        save_in_cmdline_history = true,
        -- the type of the external input buffer to use (the only supported value is currently "dressing")
        input_buffer_type = nil,
        -- callback to run after renaming, receives the result table (from LSP handler) as an argument
        post_hook = function(lsp_table)
          print(TableDump2(lsp_table))
        end,
      }
    end,
  },

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
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
    'stevearc/oil.nvim',
    lazy = true,
    enabled = true,
    opts = {},
    config = function()
      require 'custom.plugins.configs.oil'
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      vim.keymap.set('n', '<leader>o', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    end,
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'VonHeikemen/fine-cmdline.nvim',
    dependencies = {
      { 'MunifTanjim/nui.nvim' },
    },
    lazy = false,
    enabled = false,
    config = function()
      -- vim.api.nvim_set_keymap("n", "<CR>", "<cmd>FineCmdline<CR>", { noremap = true })
      vim.keymap.set({ 'n' }, ':', '<cmd>FineCmdline<CR>', { noremap = true })
      vim.keymap.set({ 'x', 'v' }, ':', ":<C-u>FineCmdline '<,'><CR>", { noremap = true })
    end,
  },
  {
    'kdheepak/tabline.nvim',
    enabled = false,
    lazy = false,
  },
  {
    'tiagovla/scope.nvim',
    enabled = false,
    lazy = false,
  },
  require 'plugins.wilder',
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
  require 'plugins.harpoon',
  require 'plugins.vim_matchup',
  require 'plugins.indent_blankline',
  require 'plugins.lint',
  require 'plugins.autopairs',

  require 'plugins.neo-tree', -- NOTE: Slower than nvim-tree but better git support and has box to edit things, and indication of changes and bulk rename and select,
  -- require 'plugins.nnn', -- NOTE: works fine but needs better NNN configurations with tui-preview plugin ,
  -- require 'plugins.lf', -- NOTE: Appear to bugout with my toggleterm config
  require 'plugins.colorizer',
  require 'plugins.better_scape',
  require 'plugins.noice',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
}, lazy_config)

-- vim: ts=2 sts=2 sw=2 et
