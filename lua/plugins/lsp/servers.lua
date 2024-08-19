local capabilities = require 'plugins.lsp.capabilities'

local lspconfig = require 'lspconfig'
local basedpyright_capabilities = vim.tbl_deep_extend('force', capabilities or {}, {})
basedpyright_capabilities.textDocument.publishDiagnostics = {
  relatedInformation = false, -- Disable related information
  tagSupport = {
    valueSet = {}, -- Disable tag support
  },
  dynamicRegistration = false,
}

local servers = {
  bashls = {},
  --[[ OLS  https://github.com/DanielGavin/ols.gits ]]
  ols = {
    cmd = { 'ols' },
    root_dir = function(fname)
      return require('lspconfig').util.root_pattern('ols.json', '.git')(fname) or vim.fn.getcwd()
    end,
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
    -- capabilities = capabilities,
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = true
      client.server_capabilities.documentFormattingRangeProvider = true
    end,

    -- root_dir = lspconfig.util.root_pattern '.git',
    root_dir = function(fname)
      return require('lspconfig').util.root_pattern('.git', 'pyproject.toml', 'setup.py')(fname) or vim.fn.getcwd()
      -- return require('lspconfig').util.root_pattern('.git', , 'setup.py', 'setup.cfg')(fname) or vim.fn.getcwd()
    end,

    filetypes = { 'python' },
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = 'off', -- Options: "off", "basic", "strict"
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
        },

        linting = {
          enabled = false, -- Disable linting
          pylintEnabled = false, -- If using pylint, disable it as well
          flake8Enabled = false, -- If using flake8, disable it as well
        },
      },
    },
  },

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
