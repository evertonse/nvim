-- Custom handler to use vim.ui.input instead of quickfix list
local function custom_handler(err, result, ctx, config)
  if err ~= nil then
    vim.notify('Error: ' .. err.message, vim.log.levels.ERROR)
    return
  end

  if result == nil or vim.tbl_isempty(result) then
    vim.notify('No results found', vim.log.levels.INFO)
    return
  end

  local locations = result
  if vim.tbl_islist(result) then
    if #result == 1 then
      locations = result[1]
    end
  end

  local function jump_to_location(location)
    local uri = location.uri or location.targetUri
    local bufnr = vim.uri_to_bufnr(uri)
    vim.fn.bufload(bufnr)
    local range = location.range or location.targetSelectionRange
    local start = range.start
    vim.api.nvim_win_set_buf(0, bufnr)
    vim.api.nvim_win_set_cursor(0, { start.line + 1, start.character + 1 })
  end

  if vim.tbl_islist(result) and #result > 1 then
    local choices = {}
    for i, loc in ipairs(result) do
      table.insert(choices, string.format('%d: %s', i, loc.uri))
    end
    vim.ui.input({ prompt = 'Choose a location:\n' .. table.concat(choices, '\n') .. '\n' }, function(choice)
      if choice then
        local index = tonumber(choice)
        if index and result[index] then
          jump_to_location(result[index])
        else
          vim.notify('Invalid choice', vim.log.levels.WARN)
        end
      end
    end)
  else
    jump_to_location(locations)
  end
end

-- NOTE: read below for intructions
--    https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/
return {
  { -- LSP Configuration & Plugins
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    'neovim/nvim-lspconfig',
    lazy = true,
    event = {
      'BufReadPost',
      'BufNewFile',
      'VimEnter',
    },
    -- event = 'BufReadCmd', -- NOTE: It hangs in the first opned buffer for some reason? I thought it was just an event
    dependencies = require 'plugins.lsp.dependencies',
    config = function()
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

      local basedpyright_capabilities = vim.tbl_deep_extend('force', capabilities, {})
      basedpyright_capabilities.textDocument.publishDiagnostics = {
        relatedInformation = true, -- Disable related information
        tagSupport = {
          valueSet = {}, -- Disable tag support
        },
        dynamicRegistration = true,
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

      local setup_ols_no_matter_what = true
      if setup_ols_no_matter_what and not OnWindows() then
        local server_opts = servers.ols or {}
        -- This handles overriding only values explicitly passed
        -- by the server configuration above. Useful when disabling
        -- certain features of an LSP (for example, turning off formatting for tsserver)
        server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})
        lspconfig['ols'].setup(server_opts)
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
    end,
  },
}
