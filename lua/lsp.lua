local DEBUG = false
local Inspect = DEBUG and Inspect or function(arg) end
local DumpInspect = DEBUG and DumpInspect or function(arg) end

local function deduplicate_items_from_goto_definition(items)
  local seen = {}
  for i = 1, #items do
    local item = items[i]
    if item then
      local key = item.filename .. ':' .. item.lnum
      if seen[key] then
        items[i] = nil
      else
        seen[key] = true
      end
    end
  end
end

local get_token_text = function(bufnr, token)
  local buf = bufnr
  local line = token.line
  local start_col = token.start_col
  local end_col = token.end_col

  local text = vim.api.nvim_buf_get_text(buf, line, start_col, line, end_col, {})[1]
  return text
end

local lsp_enable_all = function()
  local lsp_folder = vim.fn.stdpath 'config' .. '/after/lsp'
  local handle = vim.loop.fs_scandir(lsp_folder)
  if not handle then
    vim.notify('lsp: Could not open directory: ' .. lsp_folder)
    return
  end

  vim.schedule(function()
    while true do
      local name, _ = vim.loop.fs_scandir_next(handle)
      if not name then
        break
      end

      if name:match '%.lua$' then
        name = name:gsub('.lua$', '')
        vim.lsp.enable(name)
      end
    end
  end)
end

local lsp_keymaps = function(event)
  local map = function(keys, func, desc, mode, opts)
    mode = mode or 'n'
    opts =
      vim.tbl_deep_extend('force', { noremap = true, expr = true, buffer = event and event.buf or nil, desc = 'LSP: ' .. desc }, opts or {})
    vim.keymap.set(mode, keys, func, opts)
  end

  local on_list = function(options)
    if #options.items == 1 then
      vim.lsp.buf.definition()
    elseif #options.items == 2 and vim.bo.filetype == 'lua' then
      local item = options.items[1]
      local b = item.bufnr or vim.fn.bufadd(item.filename)
      -- Save position in jumplist
      vim.cmd "normal! m'"
      vim.bo[b].buflisted = true
      local win = vim.api.nvim_get_current_win()
      local w = win
      local reuse_win = true
      if reuse_win then
        w = vim.fn.win_findbuf(b)[1] or w
        if w ~= win then
          vim.api.nvim_set_current_win(w)
        end
      end
      vim.api.nvim_win_set_buf(w, b)
      vim.api.nvim_win_set_cursor(w, { item.lnum, item.col - 1 })
      vim._with({ win = w }, function()
        -- Open folds under the cursor
        vim.cmd 'normal! zv'
      end)
      return
    else
      -- If there are multiple items, set the quickfix list and open it
      vim.fn.setqflist({}, ' ', options)
      vim.cmd 'horizontal copen'
      vim.cmd 'resize 6'
    end
  end

  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-t>.
  -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  map('gd', function()
    vim.lsp.buf.definition { on_list = on_list }
  end, '[G]oto [D]efinition')
  map('gD', vim.lsp.buf.declaration, '[G]o to [*D*]eclaration')

  -- Find references for the word under your cursor.
  map('gr', function(args)
    require('telescope.builtin').lsp_references(args)
  end, '[G]oto [R]eferences')

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  map('gi', function(args)
    require('telescope.builtin').lsp_implementations(args)
  end, '[G]oto [I]mplementation')

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  map('<leader>ltd', function(args)
    require('telescope.builtin').lsp_type_definitions(args)
  end, 'Type [D]efinition')

  -- Fuzzy find all the symbols in your current document.
  --  Symbols are things like variables, functions, types, etc.
  map('<leader>lds', function(args)
    require('telescope.builtin').lsp_document_symbols(args)
  end, '[L]SP [D]ocument [S]ymbols')

  -- Fuzzy find all the symbols in your current workspace.
  --  Similar to document symbols, except searches over your entire project.
  map('<leader>ls', function(args)
    require('telescope.builtin').lsp_dynamic_workspace_symbols(args)
  end, '[L]SP workspace [S]ymbols')

  -- Rename the variable under your cursor.
  --  Most Language Servers support renaming across files, etc.
  -- map('<leader>lr', vim.lsp.buf.rename, '[L]SP [R]ename')
  local rename_func = function()
    local inc_rename_available, _ = vim.g.self.inc_rename and pcall(require, 'inc_rename')
    if inc_rename_available then
      return function()
        return ':IncRename ' .. vim.fn.expand '<cword>' .. '<Down>'
      end
    else
      return vim.lsp.buf.rename
    end
  end
  map('<leader>lr', rename_func(), '[L]SP [R]ename')

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  map('<leader>lca', vim.lsp.buf.code_action, '[L]SP [C]ode [A]ction')
  -- Define a function to check if LSP is attached and call hover if it is
  local function lsp_hover_or_fallback()
    local clients = vim.lsp.get_clients()
    if next(clients) ~= nil then
      vim.lsp.buf.hover()
    else
      -- Fallback to the default 'K' behavior (looking up man pages)
      -- vim.api.nvim_feedkeys('K', 'n', false)
    end
  end

  -- Opens a popup that displays documentation about the word under your cursor
  --  See `:help K` for why this keymap.
  map('K', (vim.version().minor >= 10) and lsp_hover_or_fallback or vim.lsp.buf.hover, 'Hover Documentation')
  -- map('K', vim.lsp.buf.hover, 'Hover Documentation')

  -- WARN: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header.
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Make sure to replace '<leader>r' with the keybinding of your choice.
  local _ = false and map('<leader>lf', vim.lsp.buf.format, 'Ranged [L]sp [F]formatting', 'v')

  map('[d', function()
    vim.diagnostic.jump { count = -1, float = true }
  end, 'Go to previous [D]iagnostic message', 'n', { noremap = true, expr = false, buffer = 0 })

  map(']d', function()
    vim.diagnostic.jump { count = 1, float = true }
  end, 'n', { noremap = true, expr = false, buffer = 0 })
end

local lsp_optimize_server_capabilites = function(client)
  DumpInspect('server_capabilities', { client.server_capabilities })
  client.server_capabilities.codeActionProvider = nil
  client.server_capabilities.codeLensProvider = nil
  client.server_capabilities.colorProvider = nil
  -- client.server_capabilities.definitionProvider = false
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentHighlightProvider = false
  client.server_capabilities.documentOnTypeFormattingProvider = nil
  client.server_capabilities.documentRangeFormattingProvider = true

  -- Setting `documentSymbolProvider` false make incline and dropbar be unable to show nested symbols
  -- client.server_capabilities.documentSymbolProvider = false

  client.server_capabilities.executeCommandProvider = nil

  client.server_capabilities.foldingRangeProvider = false
  -- client.server_capabilities.hoverProvider = false
  -- client.server_capabilities.implementationProvider = false
  client.server_capabilities.inlayHintProvider = nil
  -- client.server_capabilities.referencesProvider = false
  -- client.server_capabilities.renameProvider = nil

  if client.name == 'lua_ls' then
    -- client.server_capabilities.semanticTokensProvider = nil
  end

  -- client.server_capabilities.signatureHelpProvider = nil

  -- client.server_capabilities.textDocumentSync = nil
  -- client.server_capabilities.typeDefinitionProvider = false
  client.server_capabilities.workspaceSymbolProvider = nil
end

-- Force disable all unnecessary capabilities + dynamic features
local lsp_optimize_client_capabilites = function(capabilities, make_defaults)
  local capabilities = capabilities or (make_defaults and vim.lsp.protocol.make_client_capabilities() or {})
  capabilities = vim.tbl_deep_extend('force', capabilities, {
    general = {
      positionEncodings = {
        'utf-8',
        -- 'utf-16',
        -- 'utf-32',
      },
    },

    textDocument = {
      diagnostic = {
        dynamicRegistration = false,
      },
      inlayHint = {
        dynamicRegistration = false,
        resolveSupport = {
          properties = {
            'textEdits',
            'tooltip',
            'location',
            'command',
          },
        },
      },
      semanticTokens = {
        dynamicRegistration = false,
        tokenTypes = {
          'namespace',
          'type',
          'class',
          'enum',
          'interface',
          'struct',
          'typeParameter',
          'parameter',
          'variable',
          'property',
          'enumMember',
          'event',
          'function',
          'method',
          'macro',
          'keyword',
          'modifier',
          'comment',
          'string',
          'number',
          'regexp',
          'operator',
          'decorator',
        },
        tokenModifiers = {
          'declaration',
          'definition',
          'readonly',
          'static',
          'deprecated',
          'abstract',
          'async',
          'modification',
          'documentation',
          'defaultLibrary',
        },
        formats = { 'relative' },
        requests = {
          range = true,
          full = { delta = true },
        },

        overlappingTokenSupport = false,
        multilineTokenSupport = false,
        serverCancelSupport = false,
        augmentsSyntaxTokens = true,
      },

      synchronization = {
        dynamicRegistration = false,

        willSave = false,
        willSaveWaitUntil = false,
        didSave = true,
      },
      codeAction = {
        dynamicRegistration = false,
        isPreferredSupport = false,
        dataSupport = false,
        resolveSupport = {
          properties = { 'edit', 'command' },
        },
      },

      codeLens = {
        dynamicRegistration = false,
        resolveSupport = {
          properties = { 'command' },
        },
      },
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
        foldingRange = {
          collapsedText = true,
        },
      },

      formatting = {
        dynamicRegistration = false,
      },
      rangeFormatting = {
        dynamicRegistration = false,
        rangesSupport = false,
      },

      completion = {
        dynamicRegistration = false,
        completionItem = {
          snippetSupport = false,
          commitCharactersSupport = false,
          preselectSupport = false,
          deprecatedSupport = true,
          resolveSupport = {
            properties = {
              'additionalTextEdits',
              'command',
            },
          },
        },
        completionList = {
          itemDefaults = {
            'editRange',
            'insertTextFormat',
            'insertTextMode',
            'data',
          },
        },
        contextSupport = true,
      },
      declaration = {
        linkSupport = true,
      },
      definition = {
        linkSupport = true,
        dynamicRegistration = false,
      },
      implementation = {
        linkSupport = true,
      },
      typeDefinition = {
        linkSupport = true,
      },
      hover = {
        dynamicRegistration = true,
      },
      signatureHelp = {
        dynamicRegistration = false,
        signatureInformation = {
          activeParameterSupport = true,
          parameterInformation = {
            labelOffsetSupport = true,
          },
        },
      },
      references = {
        dynamicRegistration = false,
      },
      documentHighlight = {
        dynamicRegistration = false,
      },
      documentSymbol = {
        dynamicRegistration = false,
        hierarchicalDocumentSymbolSupport = false,
      },
      rename = {
        dynamicRegistration = true,
        prepareSupport = true,
      },
      publishDiagnostics = {
        relatedInformation = false,
        dataSupport = false,
      },
      callHierarchy = {
        dynamicRegistration = false,
      },
      colorProvider = { dynamicRegistration = false },
    },
    workspace = {
      configuration = false,
      executeCommand = { dynamicRegistration = false },
      symbol = {
        dynamicRegistration = false,
      },
      didChangeConfiguration = {
        dynamicRegistration = false,
      },
      workspaceFolders = false,
      applyEdit = false,
      workspaceEdit = {
        resourceOperations = { 'rename', 'create', 'delete' },
      },
      semanticTokens = {
        refreshSupport = false,
      },
      didChangeWatchedFiles = {
        dynamicRegistration = false,
        relativePatternSupport = false,
      },
      inlayHint = {
        refreshSupport = true,
      },
    },
    experimental = nil,
    window = {
      workDoneProgress = false,
      showMessage = {
        messageActionItem = {
          additionalPropertiesSupport = false,
        },
      },
      showDocument = {
        support = false,
      },
    },
  })

  return capabilities
end

local lsp_attach_autocommands = function()
  local group = vim.api.nvim_create_augroup('lsp-attach', { clear = true })
  local au = vim.api.nvim_create_autocmd

  au('LspTokenUpdate', {
    callback = function(args)
      --- Layout of args
      -- {
      --   args = {
      --     buf = 1,
      --     data = {
      --       client_id = 1,
      --       token = {
      --         end_col = 23,
      --         line = 573,
      --         marked = true,
      --         modifiers = {},
      --         start_col = 0,
      --         type = "function"
      --       }
      --     },
      --     event = "LspTokenUpdate",
      --     file = "/home/excyber/.config/nvim/lua/lsp.lua",
      --     id = 80,
      --     match = "/home/excyber/.config/nvim/lua/lsp.lua"
      --   }
      -- }

      if args.data == nil then
        return
      end
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name ~= 'lua_ls' then
        return
      end
      local token = args.data.token

      --- Make 'vim' global act as default library, this is done for every 'vim' token.
      --- This might not be the best way to do it ask neovim subreddit (TODO)
      if token.type == 'variable' and token.modifiers.global == true and not token.modifiers.readonly then
        local token_text = get_token_text(args.buf, token)
        if token_text == 'vim' then
          local hlgroup = '@lsp.typemod.variable.defaultLibrary'
          vim.lsp.semantic_tokens.highlight_token(token, args.buf, args.data.client_id, hlgroup)
        end
      end
    end,
  })

  --- NOTE(deccan): 'LspAttach' executes before ´on_attach´ function defined in vim.lsp.config['lua_ls']
  au('LspAttach', {
    group = group,
    callback = function(event)
      -- see:  https://github.com/Rishabh672003/Neovim/blob/main/lua/rj/lsp.lua
      local bufnr = event.buf
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client then
        return
      end
      lsp_keymaps(event)
      lsp_optimize_server_capabilites(client)

      -- Unset 'formatexpr'
      vim.bo[bufnr].formatexpr = nil
      -- Unset 'omnifunc'
      vim.bo[bufnr].omnifunc = nil

      --- Disable default formatting
      if client.name == 'tsserver' then
        client.server_capabilities.documentFormattingProvider = false
      end

      if client.name == 'lua_ls' then
        client.server_capabilities.documentFormattingProvider = false
      end

      if client:supports_method('textDocument/completion', bufnr) then
        -- Enable auto-completion
        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
      end

      if client:supports_method 'textDocument/inlayHints' then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end,
  })

  au('LspDetach', {
    group = group,
    callback = function(event)
      local buf = event.buf
      vim.api.nvim_clear_autocmds { buffer = buf, group = group }
    end,
  })
end

local lsp_ui = function()
  local icons = {
    Class = ' ',
    Color = ' ',
    Constant = ' ',
    Constructor = ' ',
    Enum = ' ',
    EnumMember = ' ',
    Event = ' ',
    Field = ' ',
    File = ' ',
    Folder = ' ',
    Function = '󰊕 ',
    Interface = ' ',
    Keyword = ' ',
    Method = 'ƒ ',
    Module = '󰏗 ',
    Property = ' ',
    Snippet = ' ',
    Struct = ' ',
    Text = ' ',
    Unit = ' ',
    Value = ' ',
    Variable = ' ',
  }

  local completion_kinds = vim.lsp.protocol.CompletionItemKind
  for i, kind in ipairs(completion_kinds) do
    completion_kinds[i] = icons[kind] and icons[kind] .. kind or kind
  end
end
local diagnostic_config = function()
  -- Diagnostic Config
  -- See :help vim.diagnostic.Opts
  vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    } or {},

    virtual_lines = {
      -- Only show virtual line diagnostics for the current cursor line
      current_line = true,
    },
    float = {
      focusable = true,
      style = 'minimal',
      border = 'single',
      -- source = 'always',
      header = '',
      prefix = '',
    },
    virtual_text = {
      source = 'if_many',
      spacing = 2,
      format = function(diagnostic)
        local diagnostic_message = {
          [vim.diagnostic.severity.ERROR] = diagnostic.message,
          [vim.diagnostic.severity.WARN] = diagnostic.message,
          [vim.diagnostic.severity.INFO] = diagnostic.message,
          [vim.diagnostic.severity.HINT] = diagnostic.message,
        }
        return diagnostic_message[diagnostic.severity]
      end,
    },
    update_in_insert = false,
  }
end

--- See all handlers with :lua vim.print(vim.tbl_keys(vim.lsp.handlers))
--- See :h vim.lsp.handlers (Note: only for server-to-client requests/notifications, not client-to-server.)
local lsp_handlers = function()
  --- NOTE: Disabled handlers. Uncomment those you WANT support for.
  for _, it in pairs {
    '$/progress',
    'callHierarchy/incomingCalls',
    'callHierarchy/outgoingCalls',

    -- 'client/registerCapability',
    -- 'client/unregisterCapability',

    'textDocument/codeLens',
    -- 'textDocument/diagnostic',
    'textDocument/documentHighlight',
    'textDocument/documentSymbol',
    'textDocument/formatting',
    'textDocument/inlayHint',
    'textDocument/publishDiagnostics',
    'textDocument/rangeFormatting',
    -- 'textDocument/rename',
    -- 'textDocument/signatureHelp',
    -- 'textDocument/completion',
    -- 'textDocument/hover',

    -- 'hover',
    -- 'signature_help',

    'window/logMessage',
    'window/showDocument',
    'window/showMessage',
    'window/showMessageRequest',
    'window/workDoneProgress/create',

    'workspace/configuration',
    'workspace/applyEdit',
    'workspace/workspaceFolders',
    'workspace/executeCommand',
    'workspace/inlayHint/refresh',
    -- 'workspace/semanticTokens/refresh',
    -- 'workspace/symbol',

    -- 'typeHierarchy/subtypes',
    -- 'typeHierarchy/supertypes',
  } do
    vim.lsp.handlers[it] = function(_, _, ctx)
      --- Defined by JSON RPC
      -- ParseError = -32700,
      -- InvalidRequest = -32600,
      -- MethodNotFound = -32601,
      -- InvalidParams = -32602,
      -- InternalError = -32603,
      -- serverErrorStart = -32099,
      -- serverErrorEnd = -32000,
      -- ServerNotInitialized = -32002,
      -- UnknownErrorCode = -32001,

      --- Defined by the protocol.
      -- RequestCancelled = -32800,
      -- ContentModified = -32801,
      -- ServerCancelled = -32802,

      --- NOTE(deccan 2025-05-20): Right now I think preteding the method is not found is fine to just make every plugins or neovim native feature think that is just not supported
      -- return nil, vim.lsp.rpc.rpc_response_error(vim.lsp.protocol.ErrorCodes.MethodNotFound, 'No handler', { method = ctx.method })
      return nil, vim.lsp.rpc.rpc_response_error(vim.lsp.protocol.ErrorCodes.RequestCancelled, 'Disabled', { method = ctx.method })
    end
  end
  if true then
    return
  end

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

  if vim.g.self.linting_by_default then
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = true,
      update_in_insert = false,
    })
  else
    vim.lsp.handlers['textDocument/publishDiagnostics'] = function() end
  end

  -- Optional: Remove LSP handlers for unwanted features
  -- vim.lsp.handlers["textDocument/hover"] = function() end
  -- vim.lsp.handlers["textDocument/signatureHelp"] = function() end

  -- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
  vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
    config = config
      or {
        border = {
          { '╭', 'Comment' },
          { '─', 'Comment' },
          { '╮', 'Comment' },
          { '│', 'Comment' },
          { '╯', 'Comment' },
          { '─', 'Comment' },
          { '╰', 'Comment' },
          { '│', 'Comment' },
        },
      }
    config.focus_id = ctx.method
    if not (result and result.contents) then
      return
    end
    local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
    if vim.tbl_isempty(markdown_lines) then
      return
    end
    return vim.lsp.util.open_floating_preview(markdown_lines, 'markdown', config)
  end
end
local lsp_config = function()
  --- NOTE: The table set here gets merged with default
  ---       Preserving OUR settings, it only gets overriden by capabilites from runtime ´lsp/´ configs
  ---       Therefore lsp/lua_ls > vim.lsp.config('*',...) > default
  ---       Since it's just a table, functions like on_init or on_attach will get completely overriden
  ---       If you wanna preserve some logic, you might wanna import your default ´on_init´ function and call inside your specific ´on_init´.
  ---       h: lsp + decent examplation at https://lsp-zero.netlify.app/blog/lsp-config-without-plugins.html
  ---
  ---       Another thing to consider, plugins such as ´blink.cmp´ might also have a call to
  ---       vim.lsp.config('*',...) which means whoever it'll get merged as well, but whoever gets called later has priority.
  ---       Idk if there's a way to ensure that out config is the very last without setting on runtime lsp/*.lua.
  ---       I'm unsure if vim.schedule solves it, probably not because some plugin might have a very late setup.
  ---
  ---       With that said then IMPORTANT(deccan 2025-05-20): As of right now, blink.cmp late merge their capabilites.textDocument.completion into ours.
  ---       We're gonna trust it's good for them to have priority and we're mess with anything else to squeeze performance.

  --- These two achieve the same:
  -- vim.lsp.config('*', {
  vim.lsp.config['*'] = {
    --- @alias vim.lsp.client.on_init_cb fun(client: vim.lsp.Client, init_result: lsp.InitializeResult)
    on_init = function(client, init_result)
      --- WARNING: If a client overrides this config, then the server will handle everythin
      -- DumpInspect('on_init', client)
    end,

    --- @alias vim.lsp.client.before_init_cb fun(params: lsp.InitializeParams, config: vim.lsp.ClientConfig)
    before_init = function(params, config)
      -- DumpInspect('before_init', { params = params, config = config })
    end,

    --- @alias vim.lsp.client.on_attach_cb fun(client: vim.lsp.Client, bufnr: integer)
    on_attach = function(client, bufnr)
      -- DumpInspect('on_attach', client)
    end,

    --- @alias vim.lsp.client.on_exit_cb fun(code: integer, signal: integer, client_id: integer)
    on_exit = function(client, bufnr) end,

    capabilities = lsp_optimize_client_capabilites(),
  }
end

LspEditLog = function()
  vim.lsp.set_log_level 'debug'
  vim.cmd.edit(vim.lsp.get_log_path())
end
-- See for exmaples: https://www.reddit.com/r/neovim/comments/1khidkg/mind_sharing_your_new_lsp_setup_for_nvim_011/
-- TODO check this config.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
local schedule = function(func)
  if false then
    vim.schedule(func)
  else
    func()
  end
end

schedule(function()
  diagnostic_config()
  lsp_handlers()
  lsp_config()
  lsp_ui()
  lsp_attach_autocommands()
  lsp_enable_all()
end)

--- Resources:
---     https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/
--- Since Neovim v0.11
---
---     In normal mode, grn renames all references of the symbol under the cursor.
---
---     In normal mode, gra shows a list of code actions available in the line under the cursor.
---
---     In normal mode, grr lists all the references of the symbol under the cursor.
---
---     In normal mode, gri lists all the implementations for the symbol under the cursor.
---
---     In normal mode, gO lists all symbols in the current buffer.
---
---     In insert mode, <Ctrl-s> displays the function signature of the symbol under the cursor.
