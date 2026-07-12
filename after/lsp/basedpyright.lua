local old = { -- https://docs.basedpyright.com/#/settings
  cmd = { 'basedpyright-langserver', '--stdio' },
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

---@brief
---
--- https://detachhead.github.io/basedpyright
---
--- `basedpyright`, a static type checker and language server for python

local function set_python_path(command)
  local path = command.args
  local clients = vim.lsp.get_clients {
    bufnr = vim.api.nvim_get_current_buf(),
    name = 'basedpyright',
  }
  for _, client in ipairs(clients) do
    if client.settings then
      ---@diagnostic disable-next-line: param-type-mismatch
      client.settings.python = vim.tbl_deep_extend('force', client.settings.python or {}, { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
    end
    client:notify('workspace/didChangeConfiguration', { settings = nil })
  end
end

---@type vim.lsp.Config
return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyrightconfig.json',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  },
  ---@type lspconfig.settings.basedpyright
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        -- https://docs.basedpyright.com/latest/configuration/language-server-settings/
        -- Explicitly setting `basedpyright.analysis.useLibraryCodeForTypes` is **discouraged** by the official docs.
        -- Because it will override per-project configurations like `pyproject.toml`.
        -- If left unset, its default value is `true`, and it can be correctly overridden by project config files.
      },
    },
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightOrganizeImports', function()
      local params = {
        command = 'basedpyright.organizeimports',
        arguments = { vim.uri_from_bufnr(bufnr) },
      }

      -- Using client.request() directly because "basedpyright.organizeimports" is private
      -- (not advertised via capabilities), which client:exec_cmd() refuses to call.
      -- https://github.com/neovim/neovim/blob/c333d64663d3b6e0dd9aa440e433d346af4a3d81/runtime/lua/vim/lsp/client.lua#L1024-L1030
      ---@diagnostic disable-next-line: param-type-mismatch
      client.request('workspace/executeCommand', params, nil, bufnr)
    end, {
      desc = 'Organize Imports',
    })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightSetPythonPath', set_python_path, {
      desc = 'Reconfigure basedpyright with the provided python path',
      nargs = 1,
      complete = 'file',
    })
  end,
}
