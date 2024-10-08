return {
  'hkupty/nvimux',
  enabled = OnWindows(),
  config = function()
    -- Nvimux configuration
    local nvimux = require 'nvimux'
    nvimux.setup {
      config = {
        prefix = '<C-a>',
      },
      bindings = {
        { { 'n', 'v', 'i', 't' }, 's', nvimux.commands.horizontal_split },
        { { 'n', 'v', 'i', 't' }, 'v', nvimux.commands.vertical_split },
      },
    }
  end,
}
