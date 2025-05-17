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

      -- { '<leader>sf', snap.config.file { producer = 'ripgrep.file' } },
      { '<leader>sf', snap.config.file { producer = 'fd.file' } },
      { '<Leader>sb', snap.config.file { producer = 'vim.buffer' } },
      { '<Leader>so', snap.config.file { producer = 'vim.oldfile' } },
      { '<Leader>sF', snap.config.vimgrep {} },
      {
        '<Leader>sG',
        function()
          snap.run {
            prompt = 'Global Marks>',
            producer = snap.get 'consumer.fzy'(snap.get 'producer.vim.globalmarks'),
            select = snap.get('select.vim.mark').select,
            views = { snap.get 'preview.vim.mark' },
          }
        end,
      },
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
