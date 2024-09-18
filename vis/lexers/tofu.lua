local lexer = require('lexer')
local P, S = lpeg.P, lpeg.S
local C, Cmt = lpeg.C, lpeg.Cmt

local lex = lexer.new(...)
local word = (lexer.any - lexer.space)^1

-- Keywords.
lex:add_rule('keyword', lex:tag(lexer.KEYWORD, lex:word_match(lexer.KEYWORD)))

-- Functions.
lex:add_rule('function', lex:tag(lexer.KEYWORD, P'fun') * lexer.space^1 * lex:tag(lexer.FUNCTION, word))

-- Constants.
lex:add_rule('constant', lex:tag(lexer.CONSTANT, lex:word_match(lexer.CONSTANT)))

-- Types.
lex:add_rule('types', lex:tag(lexer.TYPE, lex:word_match(lexer.TYPE)))

-- Strings.
local char = P"'" * P'\\'^-1 * lexer.any * P"'"
local str = lexer.range('"')
lex:add_rule('string', lex:tag(lexer.STRING, str + char))

-- Comments.
local line_comment = lexer.to_eol('//', true)
lex:add_rule('comment', lex:tag(lexer.COMMENT, line_comment))

-- Operators.
lex:add_rule('operator', lex:tag(lexer.OPERATOR, S'!@+-*/'))

-- Numbers.
lex:add_rule('number', lex:tag(lexer.NUMBER, lexer.number))

-- Identifiers.
lex:add_rule('identifier', lex:tag(lexer.IDENTIFIER, word))

-- Keywords list.
lex:set_word_list(lexer.KEYWORD, {
  'if', 'if*', 'else', 'end', 'while', 'do', 'include', 'memory', 'const', 'offset', 'reset', 'assert', 'in', '--', 'inline', 'here', 'addr-of', 'call-like', 'take', 'peek',
})

-- Types list.
lex:set_word_list(lexer.TYPE, {
  'int', 'ptr', 'bool',
})

-- Builtin constants list.
lex:set_word_list(lexer.CONSTANT, {
  'true', 'false',
})

lexer.property['scintillua.comment'] = '//'

return lex

--local lexer = require('lexer')
--local P, S = lpeg.P, lpeg.S
--local C, Cmt = lpeg.C, lpeg.Cmt
--
--local lex = lexer.new(...)
--
--lexer.word = (lexer.any - lexer.space)^1 - lexer.number - S('\\()')
--
---- Keywords.
--lex:add_rule('keyword', lex:tag(lexer.KEYWORD, lex:word_match(lexer.KEYWORD)))
--
---- Operaotrs.
--lex:add_rule('operator', lex:tag(lexer.OPERATOR, lex:word_match(lexer.OPERATOR)))
--
---- Preprocessor.
--lex:add_rule('preprocessor', lex:tag(lexer.PREPROCESSOR, P('#') * lexer.word))
--
---- Functions.
--lex:add_rule('function', lex:tag(lexer.FUNCTION, P('$') * lexer.word) * lexer.space^1 * lex:tag(lexer.KEYWORD, P('method') + P('func')))
--
---- Types.
--lex:add_rule('types', lex:tag(lexer.TYPE, P('$') * lexer.word) * lexer.space^1 * lex:tag(lexer.KEYWORD, P('struct') + P('enum')))
--
---- Strings.
--lex:add_rule('string', lex:tag(lexer.STRING, lexer.range('"')))
--
---- Constants.
--lex:add_rule('constant', lex:tag(lexer.CONSTANT, P('$') * lexer.word + lex:word_match(lexer.CONSTANT)))
--
---- Identifiers.
--lex:add_rule('identifier', lex:tag(lexer.IDENTIFIER, lexer.word))
--
---- Comments.
--local line_comment = lexer.to_eol('\\', true)
--local block_comment = lexer.range('(', ')')
--lex:add_rule('comment', lex:tag(lexer.COMMENT, line_comment + block_comment))
--
---- Numbers.
--lex:add_rule('number', lex:tag(lexer.NUMBER, lexer.number))
--
---- Keywords list.
--lex:set_word_list(lexer.KEYWORD, {
--  'exit', 'end', 'if', 'else', 'loop', 'while', 'break', 'continue', 'for', 'ufor', 'ffor', 'from', 'to', 'step', 'switch', 'case', 'pass', 'func', 'macro', 'defer', 'return', 'struct', 'enum', 'member', 'set', 'addr', 'ref', 'alloc', 'resize', 'free', 'allot', 'fetch', 'store', 'itof', 'utof', 'ftoi', 'ftou', 'show',
--})
--
---- Operators list.
--lex:set_word_list(lexer.OPERATOR, {
--  '+', '-', '*', '/', '%', 'u/', 'u%', 'neg', '++', '--', '=', '!=', '>', '>=', '<', '<=', 'u>', 'u>=', 'u<', 'u<=', 'f+', 'f-', 'f*', 'f/', 'f%', 'fneg', 'f=', 'f!=', 'f>', 'f>=', 'f<', 'f<=', '&', '|', '^', '~', '<<', '>>', 'drop', 'nip', 'dup', 'over', 'tuck', 'swap', 'rot', '2drop', '2nip', '2dup', '2over', '2tuck', '2swap', '2rot',
--})
--
---- Constants list.
--lex:set_word_list(lexer.CONSTANT, {
--  'true', 'false', 'this',
--})
--
--lexer.property['scintillua.comment'] = '\\'
--
--return lex