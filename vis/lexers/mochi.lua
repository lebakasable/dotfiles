local lexer = require('lexer')
local P, S = lpeg.P, lpeg.S
local C, Cmt = lpeg.C, lpeg.Cmt

local lex = lexer.new(...)

-- Keywords.
lex:add_rule('keyword', lex:tag(lexer.KEYWORD, lex:word_match(lexer.KEYWORD)))

-- Builtin constants.
lex:add_rule('builtin', lex:tag(lexer.CONSTANT_BUILTIN, lex:word_match(lexer.CONSTANT_BUILTIN)))

-- Types.
local type_name = lexer.upper * (lexer.alnum + P('_'))^0
lex:add_rule('type', lex:tag(lexer.TYPE, type_name + lex:word_match(lexer.TYPE)))

-- Strings.
local sq_str = lexer.range("'", true)
local dq_str = lexer.range('"')
lex:add_rule('string', lex:tag(lexer.STRING, sq_str + dq_str))

-- Functions.
local func = lex:tag(lexer.FUNCTION, lexer.word)
lex:add_rule('function', func * #(lexer.space^0 * '('))

-- Identifiers.
local identifier = lexer.word - type_name
lex:add_rule('identifier', lex:tag(lexer.IDENTIFIER, identifier))

-- Comments.
local line_comment = lexer.to_eol('//', true)
lex:add_rule('comment', lex:tag(lexer.COMMENT, line_comment))

-- Numbers.
lex:add_rule('number', lex:tag(lexer.NUMBER, lexer.number))

-- Operators.
lex:add_rule('operator', lex:tag(lexer.OPERATOR, S('+-/*%<>!=:.,()[]{}@&')))

-- Fold points.
lex:add_fold_point(lexer.COMMENT, '//')
lex:add_fold_point(lexer.OPERATOR, '{', '}')

-- Keyword list.
lex:set_word_list(lexer.KEYWORD, {
  'include', 'struct', 'pub', 'fn', 'var', 'mut', 'as', 'do', 'while', 'if', 'else', 'inline', 'enum', 'impl', 'match', 'interface',
  'sizeOf', 'cast',
})

-- Builtin constant list.
lex:set_word_list(lexer.CONSTANT_BUILTIN, {
  'true', 'false',
})

-- Type list.
lex:set_word_list(lexer.TYPE, {
  'u8', 'u64', 'bool', 'char',
})

lexer.property['scintillua.comment'] = '//'

return lex
