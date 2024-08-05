local capabilities = vim.lsp.protocol.make_client_capabilities()

local autocomplete_alternative_ok, autocomplete_alternative_capabilities = pcall(require, 'autocomplete.capabilities')
if autocomplete_alternative_ok then
  capabilities = vim.tbl_deep_extend('force', capabilities, autocomplete_alternative_capabilities)
  vim.keymap.set('i', '<CR>', function()
    return vim.fn.pumvisible() ~= 0 and '<C-e><CR>' or '<CR>'
  end, { expr = true, replace_keycodes = true })
end

local epo_ok, epo = pcall(require, 'epo')
if epo_ok then
  capabilities = vim.tbl_deep_extend('force', capabilities, epo.register_cap())
  vim.keymap.set('i', '<CR>', function()
    return vim.fn.pumvisible() ~= 0 and '<C-e><CR>' or '<CR>'
  end, { expr = true, replace_keycodes = true })
end

local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_ok then
  capabilities = vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
end

capabilities.workspace = vim.tbl_deep_extend('force', capabilities.workspace, {
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
})

capabilities.textDocument = vim.tbl_deep_extend('force', capabilities.textDocument, {
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
      -- TODO(jdrouhard): Add support for this
      range = true,
      full = { delta = true },
    },

    overlappingTokenSupport = true,
    -- TODO(jdrouhard): Add support for this
    multilineTokenSupport = false,
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
})

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

-- Merge default capabilities with disabled capabilities
return capabilities
