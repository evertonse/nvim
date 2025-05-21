---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  autostart = true,
  autoformat = false,
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },

  dynamicRegistration = false,
  settings = {
    Lua = {
      globals = { 'bit', 'stacktrace', 'vim', 'it', 'describe', 'before_each', 'after_each' },
      runtime = { version = 'Lua 5.1' },

      completion = {
        showWord = 'Disable',
        workspaceWord = false,
      },

      hint = {
        enable = true,
        arrayIndex = 'Disable',
      },

      -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      diagnostics = {
        globals = { 'bit', 'vim', 'it', 'describe', 'before_each', 'after_each' },
        disable = { 'missing-fields' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        -- library = {
        --   unpack(vim.api.nvim_get_runtime_file('', true)),
        -- },
        -- If unbearably slow, you can just let VIMRUNTIME instead
        library = { vim.env.VIMRUNTIME },

        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier.
      telemetry = {
        enable = false,
      },
    },
  },
}
