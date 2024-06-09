" Vim syntax file
" Language: Mochi

if exists("b:current_syntax")
  finish
endif

syntax case match

" Keywords
syntax keyword mochiKeyword include struct pub fn let mut as do while if else inline enum impl match interface sizeOf cast

" Builtin constants
syntax keyword mochiBuiltinConstant true false

" Types
syntax keyword mochiType u8 u64 bool char
syntax match mochiType /\<[A-Z][A-Za-z0-9_]*\>/

" Strings
syntax region mochiString start=+'+ skip=+\\\\'+ end=+'+ contains=mochiEscape
syntax region mochiString start=+"+ skip=+\\\\\"+ end=+"+ contains=mochiEscape

" Functions
syntax match mochiFunction /\<[a-zA-Z_][a-zA-Z0-9_]*\s*(/

" Identifiers
syntax match mochiIdentifier /\<[a-zA-Z_][a-zA-Z0-9_]*\>/

" Comments
syntax match mochiComment /\/\/[^\n]*/

" Numbers
syntax match mochiNumber /\<[0-9]\+\>/

" Operators
syntax match mochiOperator /[+\-/*%<>!=:.,()[]{}@&]/

hi def link mochiKeyword Keyword
hi def link mochiBuiltinConstant Constant
hi def link mochiType Type
hi def link mochiString String
hi def link mochiFunction Function
hi def link mochiIdentifier Identifier
hi def link mochiComment Comment
hi def link mochiNumber Number
hi def link mochiOperator Operator

let b:current_syntax = "mochi"
