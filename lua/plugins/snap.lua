return {
  'camspiers/snap',
  lazy = false,
  dependencies = { 'camspiers/luarocks', opts = { rocks = { 'fzy' } } },
  config = function()
    local snap = require 'snap'
    snap.maps {

      { '<leader>S', snap.config.file { producer = 'ripgrep.file' } },
    }
  end,
}
