return {
  'gregorias/coerce.nvim',
  tag = 'v2.2',
  -- Case       Key
  -- camelCase  c
  -- dot.case   d
  -- kebab-case k
  -- n12e       n
  -- PascalCase p
  -- snake_case s
  -- UPPER_CASE u
  -- path/case  /
  lazy = false,
  config = function(_, opts)
    local default_modes = require('coerce').default_modes
    for _, mode in ipairs(default_modes) do
      mode.keymap_prefix = 'gCr'
    end

    require('coerce').setup {
      keymap_registry = require('coerce.keymap').keymap_registry(),
      -- The notification function used during error conditions.
      notify = function(...)
        return vim.notify(...)
      end,
      -- If you don’t like the default cases and modes, you can override them.

      cases = require('coerce').default_cases,
      modes = default_modes,
    }
  end,
}
