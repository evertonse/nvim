return {
  'max397574/better-escape.nvim',
  enabled = true,
  -- lazy = false,
  event = 'InsertEnter',
  config = function()
    require('better_escape').setup {
      mappings = {
        i = {
          [' '] = {
            ['<tab>'] = function()
              -- Defer execution to avoid side-effects
              vim.defer_fn(function()
                -- set undo point
                vim.o.ul = vim.o.ul
                require('luasnip').expand_or_jump()
              end, 1)
            end,
          },
          j = {
            -- These can all also be functions
            k = '<Esc>',
            j = '<Esc>',
          },
          k = {
            -- These can all also be functions
            k = '<Esc>',
            j = '<Esc>',
          },
        },
        c = {
          j = {
            k = '<Esc>',
            j = '<Esc>',
          },
          k = {
            -- These can all also be functions
            k = '<Esc>',
            j = '<Esc>',
          },
        },
        t = {
          j = {
            k = '<Esc>',
            j = '<Esc>',
          },
          k = {
            -- These can all also be functions
            k = '<Esc>',
            j = '<Esc>',
          },
        },
        v = {
          j = {
            k = '<Esc>',
          },
          k = {
            -- These can all also be functions
            k = '<Esc>',
            j = '<Esc>',
          },
        },
        s = {
          j = {
            k = '<Esc>',
          },
          k = {
            -- These can all also be functions
            k = '<Esc>',
            j = '<Esc>',
          },
        },
      },
      timeout = vim.o.timeoutlen > 100 and vim.o.timeoutlen or 100, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
    }
  end,
}
