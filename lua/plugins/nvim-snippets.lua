return {
  'garymjr/nvim-snippets',
  lazy = false,
  opts = { create_cmp_source = true, search_paths = { (vim.fn.stdpath 'config') .. '/snippets' } },
  keys = {
    {
      '<c-y>',
      function()
        if vim.snippet.active { direction = 1 } then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
          return
        end
        return '<Tab>'
      end,
      expr = true,
      silent = true,
      mode = 'i',
    },
    {
      '<Tab>',

      function()
        vim.schedule(function()
          vim.snippet.jump(1)
        end)
      end,
      expr = true,
      silent = true,
      mode = 's',
    },
    {
      '<S-Tab>',
      function()
        if vim.snippet.active { direction = -1 } then
          vim.schedule(function()
            vim.snippet.jump(-1)
          end)
          return
        end

        return '<S-Tab>'
      end,
      expr = true,
      silent = true,
      mode = { 'i', 's' },
    },
  },
}
