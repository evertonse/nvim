return {
  'camspiers/snap',
  lazy = false,
  dependencies = { 'camspiers/luarocks', opts = { rocks = { 'fzy' } } },
  config = function()
    local snap = require 'snap'
    snap.maps {

      -- { '<leader>Sf', snap.config.file { producer = 'ripgrep.file' } },
      { '<Leader>Sb', snap.config.file { producer = 'vim.buffer' } },
      { '<Leader>So', snap.config.file { producer = 'vim.oldfile' } },
      { '<Leader>sF', snap.config.vimgrep {} },
    }
    vim.keymap.set('n', '<leader>Sf', function()
      snap.run {
        producer = snap.get 'consumer.fzy'(snap.get 'producer.ripgrep.file'),
        select = snap.get('select.file').select,
        multiselect = snap.get('select.file').multiselect,
        views = { snap.get 'preview.file' },
      }
    end)
  end,
}