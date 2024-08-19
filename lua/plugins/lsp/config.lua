return function()
  local lspconfig = require 'lspconfig'
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

  -- LSP servers and clients are able to communicate to each other what features they support.
  --  By default, Neovim doesn't support everything that is in the LSP specification.
  --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
  --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
  require 'plugins.lsp.autocommands'
  local capabilities = require 'plugins.lsp.capabilities'
  local servers = require 'plugins.lsp.servers'

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

  local servers_from_local_machine = { 'ols', 'jdtls' }
  for _, server_local in ipairs(servers_from_local_machine) do
    if not OnWindows() then
      local server_opts = servers[server_local] or {}
      -- This handles overriding only values explicitly passed
      -- by the server configuration above. Useful when disabling
      -- certain features of an LSP (for example, turning off formatting for tsserver)
      server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})
      server_opts.root_dir = server_opts.root_dir
        or function(fname)
          return lspconfig.util.root_pattern('setup.py', 'setup.cfg', 'pyproject.toml', '.git')(fname) or vim.fn.getcwd()
        end
      lspconfig[server_local].setup(server_opts)
    end
  end

  require('mason-lspconfig').setup {
    handlers = {
      function(server_name)
        local server_opts = servers[server_name] or {}
        -- This handles overriding only values explicitly passed
        -- by the server configuration above. Useful when disabling
        -- certain features of an LSP (for example, turning off formatting for tsserver)
        server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})
        lspconfig[server_name].setup(server_opts)
      end,
      zls = function()
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
      -- basedpyright = function()
      --   lspconfig.basedpyright.setup {
      --     root_dir = lspconfig.util.root_pattern '.git',
      --     settings = {
      --       basedpyright = {
      --         analysis = {
      --           typeCheckingMode = 'off', -- Options: "off", "basic", "strict"
      --         },
      --         linting = {
      --           enabled = false, -- Disable linting
      --           pylintEnabled = false, -- If using pylint, disable it as well
      --           flake8Enabled = false, -- If using flake8, disable it as well
      --         },
      --       },
      --     },
      --   }
      -- end,

      -- ['lua_ls'] = function()
      --   servers.lua_ls.capabilities = capabilities
      --   lspconfig.lua_ls.setup(servers.lua_ls)
      -- end,
    },
  }

  -- NOTE: Idk if this is global ??
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
  })

  vim.diagnostic.config {
    virtual_text = true,
    update_in_insert = false,
    float = {
      focusable = true,
      style = 'minimal',
      border = 'single',
      -- source = 'always',
      header = '',
      prefix = '',
    },
  }
end
