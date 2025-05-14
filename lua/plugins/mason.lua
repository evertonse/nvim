---@class MasonSettings
local settings = {
  ---@since 1.0.0
  -- Where Mason should put its bin location in your PATH. Can be one of:
  -- - "prepend" (default, Mason's bin location is put first in PATH)
  -- - "append" (Mason's bin location is put at the end of PATH)
  -- - "skip" (doesn't modify PATH)
  ---@type '"prepend"' | '"append"' | '"skip"'
  PATH = 'prepend',

  ---@since 1.0.0
  -- Controls to which degree logs are written to the log file. It's useful to set this to vim.log.levels.DEBUG when
  -- debugging issues with package installations.
  log_level = vim.log.levels.INFO,

  ---@since 1.0.0
  -- Limit for the maximum amount of packages to be installed at the same time. Once this limit is reached, any further
  -- packages that are requested to be installed will be put in a queue.
  max_concurrent_installers = 4,

  ---@since 1.0.0
  -- [Advanced setting]
  -- The registries to source packages from. Accepts multiple entries. Should a package with the same name exist in
  -- multiple registries, the registry listed first will be used.
  registries = {
    'github:mason-org/mason-registry',
  },

  ---@since 1.0.0
  -- The provider implementations to use for resolving supplementary package metadata (e.g., all available versions).
  -- Accepts multiple entries, where later entries will be used as fallback should prior providers fail.
  -- Builtin providers are:
  --   - mason.providers.registry-api  - uses the https://api.mason-registry.dev API
  --   - mason.providers.client        - uses only client-side tooling to resolve metadata
  providers = {
    'mason.providers.registry-api',
    'mason.providers.client',
  },

  github = {
    ---@since 1.0.0
    -- The template URL to use when downloading assets from GitHub.
    -- The placeholders are the following (in order):
    -- 1. The repository (e.g. "rust-lang/rust-analyzer")
    -- 2. The release version (e.g. "v0.3.0")
    -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
    download_url_template = 'https://github.com/%s/releases/download/%s/%s',
  },

  pip = {
    ---@since 1.0.0
    -- Whether to upgrade pip to the latest version in the virtual environment before installing packages.
    upgrade_pip = false,

    ---@since 1.0.0
    -- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
    -- and is not recommended.
    --
    -- Example: { "--proxy", "https://proxyserver" }
    install_args = {},
  },
}

return {
  'mason-org/mason.nvim',
  lazy = true,
  event = 'BufReadPre',
  cmd = {
    'MasonUpdate', --- - updates all managed registries
    'Mason', --- - opens a graphical status window
    'MasonInstall', --- <package> ... - installs/re-installs the provided packages
    'MasonUninstall', --- <package> ... - uninstalls the provided packages
    'MasonUninstallAll', --- - uninstalls all packages
    'MasonLog', --- - opens the mason.nvim log file in a new tab window
  },
  opts = settings,
  config = function(opts)
    require('mason').setup(opts)
    local ensure_installed = { 'stylua' }
    -- NOTE: These 2 line ilustrate what mason doesn automatically, hence we need a event to make the server appear in path
    -- $ ~/.local/share/nvim/mason/bin/
    -- vim.env.PATH = vim.fn.stdpath 'data' .. '/mason/bin' .. ':' .. vim.env.PATH
  end,
}
