-- NOTE: read below for intructions
--    https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/
return {
  { -- LSP Configuration & Plugins
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    'neovim/nvim-lspconfig',
    -- lazy = false,
    -- event = 'VimEnter',
    event = 'BufEnter',
    -- event = 'User FilePost',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        opts = {
          -- Options related to LSP progress subsystem
          progress = {
            poll_rate = 200, -- How and when to poll for progress messages
            suppress_on_insert = true, -- Suppress new messages while in insert mode
            ignore_done_already = true, -- Ignore new tasks that are already complete
            ignore_empty_message = true, -- Ignore new tasks that don't contain a message
            -- Clear notification group when LSP server detaches
            ignore = {}, -- List of LSP servers to ignore

            -- Options related to how LSP progress messages are displayed as notifications
            display = {
              render_limit = 8, -- How many LSP messages to show at once
              done_ttl = 2, -- How long a message should persist after completion
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
            poll_rate = 300, -- How frequently to update and render notifications
            filter = vim.log.levels.INFO, -- Minimum notifications level
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
              normal_hl = 'Comment', -- Base highlight group in the notification window
              winblend = 22, -- Background color opacity in the notification window
              border = 'none', -- Border around the notification window
              zindex = 20000, -- Stacking priority of the notification window
              max_width = 0, -- Maximum width of the notification window
              max_height = 0, -- Maximum height of the notification window
              x_padding = 1, -- Padding from right edge of window boundary
              y_padding = 0, -- Padding from bottom edge of window boundary
              align = 'bottom', -- How to align the notification window
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
            level = vim.log.levels.WARN, -- Minimum logging level
            max_size = 10000, -- Maximum log file size, in KB
            float_precision = 0.01, -- Limit the number of decimals displayed for floats
            -- Where Fidget writes its logs to
            path = string.format('%s/fidget.nvim.log', vim.fn.stdpath 'cache'),
          },
        },
      },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gD', vim.lsp.buf.declaration, 'Go to [D]eclaration')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>ltd', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>lds', require('telescope.builtin').lsp_document_symbols, '[L]SP [D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ls', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[L]SP workspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          -- map('<leader>lr', vim.lsp.buf.rename, '[L]SP [R]ename')
          local rename_func = function()
            local inc_rename_available, _ = pcall(require, 'inc_rename')
            if inc_rename_available then
              vim.cmd('IncRename ' .. vim.fn.expand '<cword>')
            else
              vim.lsp.buf.rename()
            end
          end
          map('<leader>lr', rename_func, '[L]SP [R]ename')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>lca', vim.lsp.buf.code_action, '[L]SP [C]ode [A]ction')
          -- Define a function to check if LSP is attached and call hover if it is
          local function lsp_hover_or_fallback()
            local clients = vim.lsp.buf.get_client()
            if next(clients) ~= nil then
              vim.lsp.buf.hover()
            else
              -- Fallback to the default 'K' behavior (looking up man pages)
              -- vim.api.nvim_feedkeys('K', 'n', false)
            end
          end

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', lsp_hover_or_fallback, 'Hover Documentation')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Make sure to replace '<leader>r' with the keybinding of your choice.
          map('<leader>lf', vim.lsp.buf.format, 'Ranged [L]sp [F]formatting', 'v')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>lth', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(nil))
            end, '[L]SP [T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      -- Got this config from NvChad versio 2.5
      capabilities.textDocument.completion.completionItem = {
        documentationFormat = { 'markdown', 'plaintext' },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
          properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
          },
        },
      }
      -- capabilities.textDocument.sync = {
      --   openClose = true,
      --   change = 2, -- Incremental sync
      --   willSave = false,
      --   willSaveWaitUntil = false,
      --   save = false,
      -- }

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

      -- Define the capabilities you want to disable
      local disabled_capabilities = {
        textDocument = {
          completion = { dynamicRegistration = false },
          hover = { dynamicRegistration = false },
          signatureHelp = { dynamicRegistration = false },
          references = { dynamicRegistration = false },
          documentHighlight = { dynamicRegistration = false },
          documentSymbol = { dynamicRegistration = false },
          formatting = { dynamicRegistration = false },
          rangeFormatting = { dynamicRegistration = false },
          onTypeFormatting = { dynamicRegistration = false },
          definition = { dynamicRegistration = false },
          codeAction = { dynamicRegistration = false },
          codeLens = { dynamicRegistration = false },
          documentLink = { dynamicRegistration = false },
          colorProvider = { dynamicRegistration = false },
          rename = { dynamicRegistration = false },
          publishDiagnostics = { dynamicRegistration = false },
        },
        workspace = {
          didChangeConfiguration = { dynamicRegistration = false },
          didChangeWatchedFiles = { dynamicRegistration = false },
          symbol = { dynamicRegistration = false },
          executeCommand = { dynamicRegistration = false },
        },
      }

      -- Merge default capabilities with disabled capabilities
      local basedpyright_capabilities = vim.tbl_deep_extend('force', capabilities, {})
      basedpyright_capabilities.textDocument.publishDiagnostics = {
        relatedInformation = false, -- Disable related information
        tagSupport = {
          valueSet = {}, -- Disable tag support
        },
      }
      basedpyright_capabilities.textDocument.publishDiagnostics = { dynamicRegistration = false }
      local servers = {
        bashls = {},
        --[[ OLS  https://github.com/DanielGavin/ols.gits ]]
        ols = {},
        ast_grep = {},
        jdtls = {},
        --[[ zig ]]
        zls = {},
        clangd = {},
        -- gopls = {},
        -- pyright = {},

        basedpyright = { -- https://docs.basedpyright.com/#/settings
          autostart = true, -- This is the important new option
          -- offset_encoding = 'utf-8', -- Not supported yet by based_pyright
          capabilities = basedpyright_capabilities,
          on_init = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentFormattingRangeProvider = false
          end,
          filetypes = { 'python' },
          settings = {
            python = {
              linting = {
                enabled = false, -- Disable linting
                pylintEnabled = false, -- If using pylint, disable it as well
                flake8Enabled = false, -- If using flake8, disable it as well
              },
            },
            basedpyright = {
              analysis = {
                disableOrganizeImports = false,
                diagnosticSeverityOverrides = {
                  reportGeneralTypeIssues = 'none',
                  reportMissingImports = 'none',
                  reportMissingTypeStubs = 'none',
                  reportPrivateUsage = 'none',
                  reportOptionalSubscript = 'none',
                  reportOptionalMemberAccess = 'none',
                  reportOptionalOperand = 'none',
                  reportOptionalCall = 'none',
                  reportOptionalIterable = 'none',
                  reportUnusedImport = 'none',
                  reportUnusedFunction = 'none',
                  reportUnusedClass = 'none',
                  reportUnusedVariable = 'none',
                  reportDuplicateImport = 'none',
                  reportUnusedCoroutine = 'none',
                  reportUnusedExpression = 'none',
                  reportUnusedParameter = 'none',
                  reportUnusedTypeParam = 'none',
                  reportUnusedTupleExpression = 'none',
                  reportUnusedCallResult = 'none',
                  reportImplicitStringConcatenation = 'none',
                  reportIncompatibleCall = 'none',
                  reportIncompatibleVariableOverride = 'none',
                  reportIncompatibleMethodOverride = 'none',
                  reportIncompatibleReturnOverride = 'none',
                },
                logLevel = 'Error',
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
                autoSearchPaths = true,
                typeCheckingMode = 'off',
              },
              include = { 'src' },
              reportMissingImports = true,
              typeCheckingMode = 'off',
              -- typeCheckingMode = 'standard',
              autoImportCompletion = false,
              diagnosticMode = 'openFilesOnly',
              autoSearchPaths = false,
              disable = {
                'E501', -- Line too long (adjust according to your needs)
              },
            },
          },
        },
        -- pylsp = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
          zls = function()
            local lspconfig = require 'lspconfig'
            lspconfig.zls.setup {
              root_dir = lspconfig.util.root_pattern('.git', 'build.zig', 'zls.json'),
              settings = {
                zls = {
                  enable_inlay_hints = true,
                  enable_snippets = true,
                  warn_style = true,
                },
              },
            }
            vim.g.zig_fmt_parse_errors = 0
            vim.g.zig_fmt_autosave = 0
          end,
          ['lua_ls'] = function()
            local lspconfig = require 'lspconfig'
            lspconfig.lua_ls.setup {
              capabilities = capabilities,
              settings = {
                Lua = {
                  runtime = { version = 'Lua 5.1' },
                  diagnostics = {
                    globals = { 'bit', 'vim', 'it', 'describe', 'before_each', 'after_each' },
                  },
                },
              },
            }
          end,
        },
      }
      vim.diagnostic.config {
        update_in_insert = false,
        float = {
          focusable = false,
          style = 'minimal',
          -- border = 'rounded',
          -- source = 'always',
          header = '',
          prefix = '',
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
