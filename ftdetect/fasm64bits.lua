-- " :help new-filetype
-- dis" :h vim.filetype.add
-- vim.cmd [[au BufRead,BufNewFile *.asm set filetype=fasm64bits]]

vim.api.nvim_create_autocmd({ 'BufReadPre' }, {
  pattern = {
    '*.asm',
    '*.ASM',
    '*.fasm',
    '*.FASM',
    '*.disasm',
    '*.DISASM',
    '*.inc',
    '*.INC',
  },
  callback = function(args)
    local bufnr = args.buf
    local our_ft = 'fasm64bits'
    if vim.b.current_syntax == our_ft then
      return
    end
    vim.b.current_syntax = 'fasm64bits'
    --- We can't set the filetype on a BufReaPre event, see filetype.lua for and explanation it
    -- vim.bo.filetype = 'fasm64bits'
    vim.b[args.buf].pre_filetype = 'fasm64bits'
    vim.bo.commentstring = ';%s'
    vim.api.nvim_command 'setlocal commentstring=;%s'
    vim.b[bufnr].did_syntax = true
  end,
})
