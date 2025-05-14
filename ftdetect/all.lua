vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local bufnr = args.buf
    local ft = vim.bo[bufnr].filetype

    if vim.treesitter.highlighter.active[args.buf] == nil then
      local has_parser = vim.treesitter.language.add(ft)
      if has_parser then
        -- Note: By default, disables regex syntax highlighting, which may be
        -- required for some plugins. In this case, add `vim.bo.syntax = 'on'` after
        -- the call to `start`.
        vim.treesitter.start(bufnr, ft)

        -- Optional: enable legacy syntax highlighting if desired
        -- vim.bo[bufnr].syntax = 'on'
      end
    end
  end,
})
