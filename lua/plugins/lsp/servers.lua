local capabilities = require 'plugins.lsp.capabilities'

local basedpyright_capabilities = vim.tbl_deep_extend('force', capabilities, {})
basedpyright_capabilities.textDocument.publishDiagnostics = {
  relatedInformation = true, -- Disable related information
  tagSupport = {
    valueSet = {}, -- Disable tag support
  },
  dynamicRegistration = true,
}

local servers = {
  bashls = {},
  --[[ OLS  https://github.com/DanielGavin/ols.gits ]]
  ols = {
    cmd = { '/home/excyber/.local/bin/ols' },
    autostart = true, -- This is the important new option
    filetypes = { 'odin' }, -- Adjust this based on your server
    autoformat = false,
  },
  ast_grep = {},
  jdtls = {
    cmd = { '/usr/bin/jdtls' },
    autostart = true,
    filetypes = { 'java' },
    autoformat = false,
  },
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
    autostart = true, -- This is the important new option
    -- cmd = {...},
    -- filetypes = { ...},
    -- capabilities = {},
    -- dynamicRegistration = false,
    settings = {
      -- Lua = {},
      Lua = {
        globals = { 'bit', 'vim', 'it', 'describe', 'before_each', 'after_each' },
        runtime = { version = 'Lua 5.1' },

        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        diagnostics = {
          globals = { 'bit', 'vim', 'it', 'describe', 'before_each', 'after_each' },
          disable = { 'missing-fields' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          -- library = vim.api.nvim_get_runtime_file('', true),
          -- Someone wrote this helps if Lua Lsp is asking whether to create luassert.
          checkThirdParty = true,
        },
        -- Do not send telemetry data containing a randomized but unique identifier.
        telemetry = {
          enable = false,
        },
      },
    },
  },
}

return servers
