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
    local our_ft = 'fasm64bits'
    if vim.b.current_syntax == our_ft then
      return
    end
    vim.b.current_syntax = 'fasm64bits'

    vim.bo.filetype = 'fasm64bits'
    vim.bo.commentstring = ';%s'
    vim.api.nvim_command 'setlocal commentstring=;%s'
  end,
})
