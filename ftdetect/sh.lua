-- " :help new-filetype
-- " :h vim.filetype.add
-- vim.cmd [[au BufRead,BufNewFile *.asm set filetype=fasm64bits]]

vim.api.nvim_create_autocmd({ 'BufReadPre' }, {
  pattern = {
    '*.sh',
    '*.zsh',
  },
  callback = function(args)
    -- vim.g.do_filetype_bash = 0

    vim.bo[args.buf].filetype = 'sh'

    if vim.treesitter.highlighter.active[args.buf] == nil then
      local has_parser = vim.treesitter.language.add 'bash'
      if has_parser then
        vim.treesitter.start(args.buf, 'bash')
      end
    end

    -- vim.bo.commentstring = ';%s'
    -- vim.api.nvim_command 'setlocal commentstring=;%s'
  end,
})
