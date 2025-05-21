if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "log"

let s:cpo_save = &cpo
set cpo&vim

let s:ft = matchstr(&ft, '^\%([^.]\)\+')

syn case ignore
syn match    logNumbers    display transparent "\<\d\|\.\d" contains=logNumber,logFloat,logOctalError,logOctal
" Same, but without octal error (for comments)
syn match    logNumbersCom    display contained transparent "\<\d\|\.\d" contains=logNumber,logFloat,logOctal
syn match    logNumber        display contained "\d\+\%(u\=l\{0,2}\|ll\=u\)\>"
"hex number
syn match    logNumber        display contained "0x\x\+\%(u\=l\{0,2}\|ll\=u\)\>"
" Flag the first zero of an octal number as something special
syn match    logOctal        display contained "0\o\+\%(u\=l\{0,2}\|ll\=u\)\>" contains=logOctalZero
syn match    logOctalZero    display contained "\<0"
"floating point number, with dot, optional exponent
syn match    logFloat        display contained "\d\+\.\d*\%(e[-+]\=\d\+\)\=[fl]\="
"floating point number, starting with a dot, optional exponent
syn match    logFloat        display contained "\.\d\+\%(e[-+]\=\d\+\)\=[fl]\=\>"
"floating point number, without dot, with exponent
syn match    logFloat        display contained "\d\+e[-+]\=\d\+[fl]\=\>"
syn match    logFloat        display contained "0x\x*\.\x\+p[-+]\=\d\+[fl]\=\>"

"hexadecimal floating point number, with leading digits, optional dot, with exponent
syn match    logFloat        display contained "0x\x\+\.\=p[-+]\=\d\+[fl]\=\>"

syn keyword logConstant true false

syn match logComment /^#.*$/ containedin=ALLBUT,logString

" Define the syntax for strings
syn region logString start=+['"]+ end=+['"]+ contains=logEscape

" Define escape sequences in strings
syn match logEscape /\\./ contained

syn match logUserFunction "\<\h\w*\ze\_s\{-}(\%(\*\h\w*)\_s\{-}(\)\@!"
syn match logUserFunctionPointer "\%((\s*\*\s*\)\@6<=\h\w*\ze\s*)\_s\{-}(.*)"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi def link logUserFunction Function
hi def link logUserFunctionPointer Function
hi def link logString String
hi def link logEscape SpecialChar
hi def link logEscape SpecialChar
hi def link logNumbers Number
hi def link logNumber Number
hi def link logFloat Number

""
unlet s:ft

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: ts=4
