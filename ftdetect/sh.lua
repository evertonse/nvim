-- " :help new-filetype
-- " :h vim.filetype.add
-- vim.cmd [[au BufRead,BufNewFile *.asm set filetype=fasm64bits]]

local _ = false
  and vim.api.nvim_create_autocmd({ 'BufReadPre' }, {
    pattern = {
      '*.sh',
      '*.zsh',
    },
    callback = function(args, ext)
      -- vim.g.do_filetype_bash = 0
      -- vim.filetype.match()

      vim.bo[args.buf].filetype = 'bash'

      Inspect { sh = { args, vim.treesitter.language.add 'bash' } }

      if vim.treesitter.highlighter.active[args.buf] == nil then
        local has_parser = vim.treesitter.language.add 'bash'
        vim.b.current_syntax = 'sh'
        if has_parser then
          vim.treesitter.start(args.buf, 'bash')
        end
      end

      -- vim.bo.commentstring = ';%s'
      -- vim.api.nvim_command 'setlocal commentstring=;%s'
    end,
  })
