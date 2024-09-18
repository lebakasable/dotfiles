local lexer = require('lexer')
local P, S = lpeg.P, lpeg.S
local C, Cmt = lpeg.C, lpeg.Cmt

local lex = lexer.new(...)

-- Keywords.
lex:add_rule('keyword', lex:tag(lexer.KEYWORD, lex:word_match(lexer.KEYWORD)))

-- Constants.
lex:add_rule('constant', P'true' + P'false')

-- Types.
lex:add_rule('type', lex:tag(lexer.TYPE, lex:word_match(lexer.TYPE)))

-- Include.
lex:add_rule('include', lex:tag(lexer.KEYWORD, P'include') * lexer.space^1 * lex:tag(lexer.STRING, lexer.word))

-- Strings.
local char = P"'" * P'\\'^-1 * (lexer.any - lexer.space)
local dq_str = lexer.range('"')
lex:add_rule('string', lex:tag(lexer.STRING, char + dq_str))

-- Functions.
local func_def = lex:tag(lexer.KEYWORD, P'fn' * lexer.space^1 * (P'extern' * lexer.space^1)^-1 * (P'variadic' * lexer.space^1)^-1) * lex:tag(lexer.FUNCTION, lexer.word)
lex:add_rule('function', func_def)

-- Identifiers.
lex:add_rule('identifier', lex:tag(lexer.IDENTIFIER, lexer.word))

-- Comments.
local line_comment = lexer.to_eol('#', true)
lex:add_rule('comment', lex:tag(lexer.COMMENT, line_comment))

-- Numbers.
lex:add_rule('number', lex:tag(lexer.NUMBER, lexer.number))

-- Operators.
lex:add_rule('operator', lex:tag(lexer.OPERATOR, S('>.:')))

-- Fold points.
lex:add_fold_point(lexer.COMMENT, '#')

-- Keyword list.
lex:set_word_list(lexer.KEYWORD, {
  'or', 'and', 'do', 'let', 'while', 'if', 'for', 'defer', 'read_as', 'here',
})

-- Type list.
lex:set_word_list(lexer.TYPE, {
  'u64', 'bool',
})

lexer.property['scintillua.comment'] = '#'

return lex
