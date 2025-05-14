local lsp_enable_all = function()
  local lsp_folder = vim.fn.stdpath 'config' .. '/after/lsp'
  local handle = vim.loop.fs_scandir(lsp_folder)
  if not handle then
    print('Could not open directory: ' .. lsp_folder)
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
  local is_nvim_11_or_higher = true
  local map = function(keys, func, desc, mode, opts)
    mode = mode or 'n'
    opts =
      vim.tbl_deep_extend('force', { noremap = true, expr = true, buffer = event and event.buf or nil, desc = 'LSP: ' .. desc }, opts or {})
    vim.keymap.set(mode, keys, func, opts)
  end

  local on_list = function(options)
    -- Check the number of items in the options
    if #options.items == 1 then
      -- vim.lsp.util.jump_to_location(options.items[1])
      vim.lsp.buf.definition()
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
  client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = true
  client.server_capabilities.hoverProvider = true
  client.server_capabilities.signatureHelpProvider = true
  client.server_capabilities.documentSymbolProvider = true
  client.server_capabilities.colorProvider = true
  client.server_capabilities.publishDiagnostics = true
  client.server_capabilities.referencesProvider = true
  client.server_capabilities.renameProvider = true
  client.server_capabilities.implementationProvider = true
  client.server_capabilities.typeDefinitionProvider = true
  client.server_capabilities.declarationProvider = true
  client.server_capabilities.workspaceSymbolProvider = true
  client.server_capabilities.selectionRangeProvider = true
  client.server_capabilities.foldingRangeProvider = true
  client.server_capabilities.completionProvider.resolveProvider = true

  -- client.server_capabilities.semanticTokensProvider = nil
  -- client.server_capabilities.textDocumentSync = nil

  client.server_capabilities.codeActionProvider = false
  client.server_capabilities.documentHighlightProvider = false
  client.server_capabilities.inlayHintProvider = false
  client.server_capabilities.codeLensProvider = false
  client.server_capabilities.linkedEditingRangeProvider = false
  client.server_capabilities.callHierarchyProvider = false
end

-- Force disable all unnecessary capabilities + dynamic features
local lsp_optimize_client_capabilites = function(capabilities)
  local capabilities = capabilities or vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend('force', capabilities, {
    workspace = {
      executeCommand = { dynamicRegistration = false },
      symbol = {
        dynamicRegistration = false,
      },
      configuration = true,
      didChangeConfiguration = {
        dynamicRegistration = false,
      },
      workspaceFolders = true,
      applyEdit = true,
      workspaceEdit = {
        resourceOperations = { 'rename', 'create', 'delete' },
      },
      semanticTokens = {
        refreshSupport = true,
      },
      didChangeWatchedFiles = {
        dynamicRegistration = false,
        relativePatternSupport = false,
      },
      inlayHint = {
        refreshSupport = true,
      },
    },
    textDocument = {
      diagnostic = {
        dynamicRegistration = false,
      },
      foldingRange = {
        dynamicRegistration = true,
        lineFoldingOnly = true,
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
        dynamicRegistration = true,
        multilineTokenSupport = true,
        completion = { completionItem = { snippetSupport = true } },
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
          -- TODO(jdrouhard): Add support for this
          range = true,
          full = { delta = true },
        },

        overlappingTokenSupport = true,
        -- TODO(jdrouhard): Add support for this
        serverCancelSupport = false,
        augmentsSyntaxTokens = true,
      },
      synchronization = {
        dynamicRegistration = false,

        willSave = true,
        willSaveWaitUntil = true,

        -- Send textDocument/didSave after saving (BufWritePost)
        didSave = true,
      },
      codeAction = {
        dynamicRegistration = true,

        isPreferredSupport = true,
        dataSupport = true,
        resolveSupport = {
          properties = { 'edit' },
        },
      },
      formatting = {
        dynamicRegistration = true,
      },
      rangeFormatting = {
        dynamicRegistration = true,
      },
      completion = {
        dynamicRegistration = false,
        completionItem = {
          documentationFormat = { 'markdown', 'plaintext' },
          snippetSupport = true,
          preselectSupport = true,
          insertReplaceSupport = true,
          labelDetailsSupport = false,
          deprecatedSupport = false,
          commitCharactersSupport = false,
          tagSupport = { valueSet = { 1 } },
          resolveSupport = {
            properties = {
              'documentation',
              'detail',
              'additionalTextEdits',
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

        -- TODO(tjdevries): Implement this
        contextSupport = false,
      },
      declaration = {
        linkSupport = true,
      },
      definition = {
        linkSupport = true,
        dynamicRegistration = true,
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
      },
      references = {
        dynamicRegistration = false,
      },
      documentHighlight = {
        dynamicRegistration = false,
      },
      documentSymbol = {
        dynamicRegistration = false,
        hierarchicalDocumentSymbolSupport = true,
      },
      rename = {
        dynamicRegistration = true,
        prepareSupport = true,
      },
      publishDiagnostics = {
        relatedInformation = true,
        dataSupport = true,
      },
      callHierarchy = {
        dynamicRegistration = false,
      },
      codeLens = { dynamicRegistration = false },
      documentLink = { dynamicRegistration = false },
      colorProvider = { dynamicRegistration = false },
    },
  })
  return capabilities
end

local lsp_attach_autocommands = function()
  local group = vim.api.nvim_create_augroup('lsp-attach', { clear = true })
  local au = vim.api.nvim_create_autocmd
  au('VimEnter', {
    group = group,
    callback = function(event)
      --vim.cmd.e()
    end,
  })

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
      ---[[ Disable default formatting
      if client.name == 'tsserver' then
        client.server_capabilities.documentFormattingProvider = false
      end

      if client.name == 'lua_ls' then
        client.server_capabilities.documentFormattingProvider = false
      end

      -- -- nightly has inbuilt completions, this can replace all completion plugins
      -- if client:supports_method("textDocument/completion", bufnr) then
      --   -- Enable auto-completion
      --   vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
      -- end
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

local lsp_config = function()
  -- Improve LSPs UI {{{
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

  if vim.g.self.linting_by_default then
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = true,
    })
  else
    vim.lsp.handlers['textDocument/publishDiagnostics'] = function() end
  end

  -- Optional: Remove LSP handlers for unwanted features
  -- vim.lsp.handlers["textDocument/hover"] = function() end
  -- vim.lsp.handlers["textDocument/signatureHelp"] = function() end

  -- Disable "No information available" notification on hover
  -- Plus define border for hover window
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

  vim.diagnostic.config {
    -- virtual_text = true, -- Show for all
    virtual_lines = {
      -- Only show virtual line diagnostics for the current cursor line
      current_line = true,
    },
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

  if false then
    vim.lsp.config('*', {
      capabilities = lsp_optimize_client_capabilites(),
      on_attach = function(client, bufnr)
        lsp_optimize_server_capabilites(client, bufnr)
        -- lsp_optimize_client_capabilites(client, bufnr)
      end,
    })
  end
end

-- TODO check this config.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
lsp_enable_all()
lsp_config()
lsp_attach_autocommands()
