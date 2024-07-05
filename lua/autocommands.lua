function ShowSearchCount()
  if vim.v.hlsearch == 1 then
    vim.fn.setreg('/', '')
    local count = vim.fn.searchcount().total
    vim.cmd('echom "Matches: ' .. count .. '"')
  end
end

vim.cmd [[
  "autocmd CmdlineEnter /,? lua ShowSearchCount()
  "autocmd CmdlineLeave /,? redrawstatus
]]

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank { higroup = 'Visual', timeout = 200 }
  end,
})

-- Apperantly " in front of a line in vimscript is a comment?
vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR> 
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd WinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
   " autocmd WinNew * :print "hello"
    autocmd FileType qf set nobuflisted
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    "autocmd FileType markdown setlocal spell
  augroup end

  augroup _tex
    autocmd!
    autocmd FileType tex setlocal wrap
    "autocmd FileType markdown setlocal spell
  augroup end

  function! Odin_settings()
    setlocal tabstop=4
    setlocal shiftwidth=4
  endfunction
  autocmd FileType odin call Odin_settings()
  
  "autocmd FileType python :setlocal tabstop=4 shiftwidth=4 expandtab
  "autocmd FileType lua :setlocal tabstop=2 shiftwidth=2 expandtab



  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd = 
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
  au BufReadPost *.xxd set ft=xxd | endif
  au BufReadPost *.bin set ft=bin | endif
  au BufReadPost *.exe set ft=bin | endif
augroup END
]]

vim.cmd [[autocmd FileType bin nnoremap <F5> :%!xxd <CR>]]
vim.cmd [[autocmd FileType bin nnoremap <F6> :%!xxd -r <CR>]]

-- vim.api.nvim_create_autocmd(
--     { "BufRead", "BufNewFile" },
--     { pattern = { "*.txt", "*.md", "*.tex" }, command = "setlocal spell" }
-- )
vim.cmd [[autocmd filetype python nnoremap <F5> :w <bar> exec '!python '.shellescape('%')<CR>]]
-- vim.cmd [[autocmd filetype c nnoremap <F5> :w <bar> exec '!gcc '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>]]
vim.cmd [[autocmd filetype cpp nnoremap <F5> :w <bar> exec '!g++ '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>]]
vim.cmd [[autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no]]
-- vim.cmd [[autocmd TermOpen * startinsert ]] -- stopinsert ]]        -- starts terminal in insert mode

-- Auto command to activate virtual environment on terminal open
-- vim.cmd([[
--     augroup AutoActivateVirtualEnv
--         autocmd!
--           autocmd TermOpen * :lua if vim.fn.isdirectory( vim.fn.getcwd() .. '/venv' ) then print('source ./venv/bin/activate') else print ('nothing') end
--     augroup end
-- ]])

-- vim.cmd [[
-- " WSL yank support
--     let s:clip = '/mnt/c/Windows/System32/clip.exe' " change this path according to your mount point
--
--     if executable(s:clip)
--
--     augroup WSLYank
--
--     autocmd!
--
--     autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, u/0
--
--     ) | endif
--
--     augroup END
--
--     endif
-- ]]
--
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('UserAutoClose', {}),
  callback = function(args)
    if vim.bo[args.buf].buftype == 'nofile' then
      vim.api.nvim_buf_delete(args.buf, {})
    end
  end,
})

-- close quicklist after enter
vim.cmd [[ autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>]]

vim.cmd [[
" autocmd FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
" there are some defaults for image directory and image name, you can change them
" let g:mdip_imgdir = 'img'
" let g:mdip_imgname = 'image'
]]
