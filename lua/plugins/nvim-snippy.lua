return {
  'dcampos/nvim-snippy',
  lazy = false,
  dependencies = { { 'honza/vim-snippets', lazy = false } },
  config = function()
    local map = vim.keymap.set
    map({ 'i', 's' }, '<C-b>', function()
      return require('snippy').can_expand_or_advance() and '<plug>(snippy-expand-or-advance)' or '<tab>'
    end, { expr = true })

    -- map({ 'i', 's' }, '<s-tab>', function()
    --   return require('snippy').can_jump(-1) and '<plug>(snippy-previous)' or '<s-tab>'
    -- end, { expr = true })
    -- map('x', '<Tab>', '<plug>(snippy-cut-text)')
    -- map('n', 'g<Tab>', '<plug>(snippy-cut-text)')
    require('snippy').setup {
      snippet_dirs = { (vim.fn.stdpath 'config') .. '/snippets' },
      enable_auto = true,
      choice_delay = 50,
      mappings = {
        is = {
          ['<Tab>'] = 'expand_or_advance',
          -- ['<C-b>'] = 'expand_or_advance',
          ['<S-Tab>'] = 'previous',
        },
        nx = {
          ['<leader>x'] = 'cut_text',
        },
      },
    }
  end,
}
