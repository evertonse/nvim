-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- Apperantly " in front of a line in vimscript is a comment?
vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR> 
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200}) 
    autocmd BufWinEnter * :set formatoptions-=cro
   " autocmd BufWinEnter * :colorscheme vs
   " autocmd BufWritePost,FileWritePost * :colorscheme vs
   " autocmd BufReadPost * :colorscheme vs
   " autocmd WinNew * :print "hello"
   " autocmd FileType qf set nobuflisted
   " autocmd VimEnter * :colorscheme vs 
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  function! Odin_settings()
    setlocal tabstop=4
    setlocal shiftwidth=4
  endfunction
  autocmd FileType odin call Odin_settings()


  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd = 
  augroup end

  augroup _alpha
    autocmd!
    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
  augroup end

  augroup _nvimtree
    autocmd!
    "autocmd WinNew * :colorscheme blue
  augroup end
   " Return to last edit position when opening files (You want this!)
  autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

]]

-- vim.cmd [[ autocmd RecordingEnter * set cmdheight=1 |  nmap Q q | echo "recording start" ]]
-- vim.cmd [[ autocmd RecordingEnter * set cmdheight=1 |  nnoremap Q q | echo "recording start" ]]
-- vim.cmd [[ autocmd RecordingEnter * set cmdheight=1 |  nnoremap q <Nop> | echo "recording start" ]]
-- vim.cmd [[ autocmd RecordingLeave * set cmdheight=0 |  nmap q q | echo "recording stop" ]]
-- vim.cmd [[ autocmd RecordingLeave * set cmdheight=0 |  nmap Q @q | echo "recording stop" ]]

-- vim.cmd([[ autocmd FileType *.c nnoremap <buffer> <F5> :wa<CR>:term gcc % -o %:r && ./%:r<CR> ]])
-- vim.cmd [[autocmd filetype cpp nnoremap <F5> :!g++ % -ggdb -o %:r && ./%:r <CR>]]
-- vim.cmd [[autocmd FileType c nnoremap <F5> :!gcc % -g -o %:r && ./%:r <CR>]]

-- vim.cmd [[autocmd FileType * nnoremap <F5> :!make run <CR>]]
vim.cmd [[
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  " au BufReadPost *.bin if &bin | %!xxd  
  au BufReadPost *.bin set ft=xxd | endif
  au BufReadPost *.bin set ft=bin | endif
  " au BufWritePre *.bin if &bin | %!xxd -r
  " au BufWritePre *.bin endif
  " au BufWritePost *.bin if &bin | %!xxd
  " au BufWritePost *.bin set nomod | endif
augroup END
]]

vim.cmd [[autocmd FileType bin,xxd nnoremap <F5> :%!xxd <CR>]]
vim.cmd [[autocmd FileType bin,xxd nnoremap <F6> :%!xxd -r <CR>]]

-- vim.api.nvim_create_autocmd(
--     { "BufRead", "BufNewFile" },
--     { pattern = { "*.txt", "*.md", "*.tex" }, command = "setlocal spell" }
-- )
vim.cmd [[autocmd filetype python nnoremap <F5> :w <bar> exec '!python '.shellescape('%')<CR>]]
-- vim.cmd [[autocmd filetype c nnoremap <F5> :w <bar> exec '!gcc '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>]]
vim.cmd [[autocmd filetype cpp nnoremap <F5> :w <bar> exec '!g++ '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>]]
vim.cmd [[autocmd filetype tex set wrap]]
vim.cmd [[autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no]]
-- vim.cmd [[autocmd TermOpen * startinsert ]] -- stopinsert ]]        -- starts terminal in insert mode

-- Auto command to activate virtual environment on terminal open
-- vim.cmd([[
--     augroup AutoActivateVirtualEnv
--         autocmd!
--           autocmd TermOpen * :lua if vim.fn.isdirectory( vim.fn.getcwd() .. '/venv' ) then print('source ./venv/bin/activate') else print ('nothing') end
--     augroup end
-- ]])

vim.cmd [[
  let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
  if executable(s:clip)
      augroup WSLYank
          autocmd!
          autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
      augroup END
  endif
]];


-- vim.api.nvim_create_autocmd("LspTokenUpdate", {
--   callback = function(args)
--     local token = args.data.token
--     print("Lsp token has been updated", token)
--   end,
-- })
--
-- close quicklist after enter
vim.cmd [[ autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>]]

vim.cmd [[
autocmd FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
" there are some defaults for image directory and image name, you can change them
" let g:mdip_imgdir = 'img'
" let g:mdip_imgname = 'image'
]]
