local dependencies = {
  -- Automatically install LSPs and related tools to stdpath for Neovim
  { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
  { 'williamboman/mason-lspconfig.nvim' },
  { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
  { 'antosha417/nvim-lsp-file-operations', config = true },

  {
    'sontungexpt/better-diagnostic-virtual-text',
    lazy = true,
    enabled = false and TOO_MANY_RANDOM_KEYBOARD_INTERRUPT_ERRORS,
    event = 'LspAttach',
    config = function(_, opts)
      require('better-diagnostic-virtual-text').setup {}
    end,
  },
  { 'SmiteshP/nvim-navic', opts = { lsp = { auto_attach = true } } },
  -- Useful status updates for LSP.
  -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
  {
    'j-hui/fidget.nvim',
    enabled = true,
    opts = {
      -- Options related to LSP progress subsystem
      progress = {
        poll_rate = vim.g.self.notification_poll_rate, -- How and when to poll for progress messages
        suppress_on_insert = true, -- Suppress new messages while in insert mode
        ignore_done_already = true, -- Ignore new tasks that are already complete
        ignore_empty_message = true, -- Ignore new tasks that don't contain a message
        -- Clear notification group when LSP server detaches
        ignore = {}, -- List of LSP servers to ignore

        -- Options related to how LSP progress messages are displayed as notifications
        display = {
          render_limit = 8, -- How many LSP messages to show at once
          done_ttl = 3, -- How long a message should persist after completion
          done_style = 'Normal', -- Highlight group for completed LSP tasks
          progress_ttl = math.huge, -- How long a message should persist when in progress
          -- Icon shown when LSP progress tasks are in progress
          progress_icon = { pattern = 'dots', period = 1 },
          -- Highlight group for in-progress LSP tasks
          progress_style = 'WarningMsg',
          group_style = 'Title', -- Highlight group for group name (LSP server name)
          icon_style = 'Question', -- Highlight group for group icons
          priority = 8000, -- Ordering priority for LSP notification group
          overrides = { -- Override options from the default notification config
            rust_analyzer = { name = 'rust-analyzer' },
          },
        },
      },

      -- Options related to notification subsystem
      notification = {
        poll_rate = vim.g.self.notification_poll_rate, -- How frequently to update and render notifications
        filter = vim.log.levels.INFO, -- Minimum notifications level
        -- filter = vim.log.levels.ERROR,
        history_size = 64, -- Number of removed messages to retain in history
        override_vim_notify = true, -- Automatically override vim.notify() with Fidget
        -- How to configure notification groups when instantiated
        -- Conditionally redirect notifications to another backend
        redirect = function(msg, level, opts)
          if opts and opts.on_open then
            return require('fidget.integration.nvim-notify').delegate(msg, level, opts)
          end
        end,

        -- Options related to how notifications are rendered as text
        view = {
          stack_upwards = true, -- Display notification items from bottom to top
          icon_separator = ' ', -- Separator between group name and icon
          group_separator = '---', -- Separator between notification groups
          -- Highlight group used for group separator
          -- group_separator_hl = 'Comment',
          group_separator_hl = 'SpecialComment',

          -- How to render notification messages
          render_message = function(msg, cnt)
            return cnt == 1 and msg or string.format('(%dx) %s', cnt, msg)
          end,
        },

        -- Options related to the notification window and buffer
        window = {
          normal_hl = 'DiagnosticUnnecessary', -- Base highlight group in the notification window
          winblend = vim.g.self.is_transparent and 0 or 20, -- Background color opacity in the notification window
          border = 'none', -- Border around the notification window
          zindex = 1, -- Stacking priority of the notification window
          max_width = 0, -- Maximum width of the notification window
          max_height = 0, -- Maximum height of the notification window
          x_padding = 1, -- Padding from right edge of window boundary
          y_padding = 1, -- Padding from bottom edge of window boundary
          align = 'top', -- How to align the notification window
          relative = 'editor', -- What the notification window position is relative to
        },
      },

      -- Options related to integrating with other plugins
      integration = {
        ['nvim-tree'] = {
          enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
        },
        ['xcodebuild-nvim'] = {
          enable = true, -- Integrate with wojciech-kulik/xcodebuild.nvim (if installed)
        },
      },

      -- Options related to logging
      logger = {
        level = vim.log.levels.Error, -- Minimum logging level
        -- level = vim.log.levels.WARN,
        max_size = 10000, -- Maximum log file size, in KB
        float_precision = 0.01, -- Limit the number of decimals displayed for floats
        -- Where Fidget writes its logs to
        path = string.format('%s/fidget.nvim.log', vim.fn.stdpath 'cache'),
      },
    },
  },

  -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
  -- used for completion, annotations and signatures of Neovim apis
  { 'folke/neodev.nvim', enabled = true, opts = {} },
}

return dependencies
