" Vim syntax file
" Language: Duk

if exists("b:current_syntax")
   finish
endif

set iskeyword=a-z,A-Z,-,*,_,!,@
syntax keyword dukTodos TODO XXX FIXME NOTE

" Keywords
syntax keyword dukKeywords if else while do end

" Builtins
syntax match dukBuiltins /drop\|dup\|over\|swap\|+\|-\|%\|=\|>\|<\|>=\|<=\|>>\|<<\||\|&\|print\|mem\|@8\|!8\|syscall1\|syscall2\|syscall3\|syscall4\|syscall5\|syscall6/

" Comments
syntax region dukCommentLine start="\\\s" end="$" contains=dukTodos

" String literals
syntax region dukString start=/\v"/ skip=/\v\\./ end=/\v"/ contains=dukEscapes

" Char literals
syntax region dukChar start=/\v'/ skip=/\v\\./ end=/\v'/ contains=dukEscapes

" Escape literals \n, \r, ....
syntax match dukEscapes display contained "\\[nr\"']"

" Number literals
syntax match dukNumber /\v(^|\s)\d+(\.\d+)?($|\s)/

highlight default link dukTodos Todo
highlight default link dukKeywords Keyword
highlight default link dukBuiltins Normal
highlight default link dukCommentLine Comment
highlight default link dukString String
highlight default link dukNumber Number
highlight default link dukChar Character
highlight default link dukEscapes SpecialChar

let b:current_syntax = "duk"
