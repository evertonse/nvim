return { -- https://docs.basedpyright.com/#/settings

  autostart = true,
  -- offset_encoding = 'utf-8', -- Not supported yet by based_pyright
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentFormattingRangeProvider = true
  end,

  root_dir = function(fname)
    -- TODO: vim.fs.root
    return {
      'pyproject.toml',
      'setup.py',
      '.git',
    }
  end,

  filetypes = { 'python' },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'off', -- Options: "off", "basic", "strict"
        -- typeCheckingMode = 'strict', -- Options: "off", "basic", "strict"
        disableOrganizeImports = true,
        diagnosticSeverityOverrides = {
          reportUnknownParameterType = false,
          reportMissingParameterType = false,
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
}
