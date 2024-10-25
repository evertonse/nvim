return {
  'gregorias/coerce.nvim',
  tag = 'v3.0.0',
  -- Case       |   Key
  -- camelCase  |   c
  -- dot.case   |   d
  -- kebab-case |   k
  -- n12e       |   n
  -- PascalCase |   p
  -- snake_case |   s
  -- UPPER_CASE |   u
  -- path/case  |   /
  lazy = false,

  config = function()
    require('coerce').setup {
      keymap_registry = require('coerce.keymap').keymap_registry(),
      -- The notification function used during error conditions.
      notify = function(...)
        return vim.notify(...)
      end,
      default_mode_keymap_prefixes = {
        normal_mode = 'gC',
        motion_mode = 'gC',
        visual_mode = 'gC',
      },
      -- If you don’t like the default cases and modes, you can override them.
      cases = require('coerce').default_cases,
      -- modes = require('coerce').get_default_modes(self.keymap_prefixes),
    }
  end,
}
