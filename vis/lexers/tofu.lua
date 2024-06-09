local lexer = require('lexer')
local P, S = lpeg.P, lpeg.S
local C, Cmt = lpeg.C, lpeg.Cmt

local lex = lexer.new(...)

-- Keywords.
lex:add_rule('keyword', lex:tag(lexer.KEYWORD, lex:word_match(lexer.KEYWORD)))

-- Types.
local type = lexer.upper * (lexer.any - lexer.space)^0
lex:add_rule('type', lex:tag(lexer.TYPE, type + lex:word_match(lexer.TYPE) - lex:word_match(lexer.CONSTANT_BUILTIN)))

-- Builtin constants.
lex:add_rule('builtin', lex:tag(lexer.CONSTANT_BUILTIN, lex:word_match(lexer.CONSTANT_BUILTIN)))

-- Strings.
local sq_str = lexer.range("'", true)
local dq_str = lexer.range('"')
lex:add_rule('string', lex:tag(lexer.STRING, sq_str + dq_str))

-- Functions.
--local func = lex:tag(lexer.FUNCTION, lexer.word)
--lex:add_rule('function', func * #(lexer.space^0 * ':'))

-- Comments.
local line_comment = lexer.to_eol('//', true)
lex:add_rule('comment', lex:tag(lexer.COMMENT, line_comment))

-- Numbers.
lex:add_rule('number', lex:tag(lexer.NUMBER, lexer.number))

-- Operators.
local operator = S('+-/*%<>@!=')
lex:add_rule('operator', lex:tag(lexer.OPERATOR, operator))

-- Identifiers.
local identifier = (lexer.any - lexer.space)^1 - type - line_comment - operator
lex:add_rule('identifier', lex:tag(lexer.IDENTIFIER, identifier))

-- Fold points.
lex:add_fold_point(lexer.COMMENT, '#')

-- Keyword list.
lex:set_word_list(lexer.KEYWORD, {
  'if', 'if*', 'else', 'end', 'while', 'begin', 'include', 'memory', 'to', 'const', 'shift', 'init', 'assert', 'do', '--', 'expand', 'here', 'addr-of', 'call-like', 'with', 'with*',
})

-- Builtin constant list.
lex:set_word_list(lexer.CONSTANT_BUILTIN, {
  'true', 'false', 'NULL',
})

-- Type list.
lex:set_word_list(lexer.TYPE, {
  'int', 'ptr', 'bool', 'addr',
})

lexer.property['scintillua.comment'] = '//'

return lex
