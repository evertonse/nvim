return {
  'camspiers/snap',
  lazy = true,

  keys = {
    { '<leader>sf' },
    { '<Leader>sb' },
    { '<Leader>so' },
    { '<Leader>sF' },
  },
  enabled = vim.version().minor >= 10,
  dependencies = { 'camspiers/luarocks', opts = { rocks = { 'fzy' } } },
  config = function()
    local snap = require 'snap'
    snap.maps {

      { '<leader>sf', snap.config.file { producer = 'ripgrep.file' } },
      { '<Leader>sb', snap.config.file { producer = 'vim.buffer' } },
      { '<Leader>so', snap.config.file { producer = 'vim.oldfile' } },
      { '<Leader>sF', snap.config.vimgrep {} },
    }
    vim.keymap.set('n', '<leader>sf', function()
      snap.run {
        producer = snap.get 'consumer.fzy'(snap.get 'producer.ripgrep.file'),
        select = snap.get('select.file').select,
        multiselect = snap.get('select.file').multiselect,
        views = { snap.get 'preview.file' },
      }
    end)
  end,
}
