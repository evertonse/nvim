-- " :help new-filetype
-- " :h vim.filetype.add
-- vim.cmd [[au BufRead,BufNewFile *.asm set filetype=fasm64bits]]

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPre' }, {
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
    -- assert(vim.bo.filetype == nil) -- If our event is Pre it should be nil otherwise runtime functions has been called before us
    vim.bo.filetype = 'fasm64bits'
    vim.bo.commentstring = ';%s'
    vim.api.nvim_command 'setlocal commentstring=;%s'
  end,
})
