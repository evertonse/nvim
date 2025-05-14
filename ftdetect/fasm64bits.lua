-- " :help new-filetype
-- " :h vim.filetype.add
-- vim.cmd [[au BufRead,BufNewFile *.asm set filetype=fasm64bits]]

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
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
  callback = function()
    vim.bo.filetype = 'fasm64bits'
    vim.bo.commentstring = ';%s'
    vim.api.nvim_command 'setlocal commentstring=;%s'
  end,
})
