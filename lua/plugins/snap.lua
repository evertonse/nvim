return {
  'camspiers/snap',
  dependencies = { 'camspiers/luarocks', opts = { rocks = { 'fzy' } } },
  config = function()
    local snap = require 'snap'
    snap.maps {

      { '<Leader>S', snap.config.file { producer = 'ripgrep.file' } },
    }
  end,
}
