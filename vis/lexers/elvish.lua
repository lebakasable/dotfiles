-- Copyright 2006-2024 Mitchell. See LICENSE.
-- Elvish LPeg lexer.

local lexer = lexer
local P, S, B = lpeg.P, lpeg.S, lpeg.B

local lex = lexer.new(...)

-- Keywords.
lex:add_rule('keyword', lex:tag(lexer.KEYWORD, lex:word_match(lexer.KEYWORD)))

-- Variables.
local var = P('$') * (lexer.word + lexer.range('{', '}'))
lex:add_rule('variable', lex:tag(lexer.VARIABLE, var))

-- Functions.
local func = P('fn ') * lexer.word
lex:add_rule('function', lex:tag(lexer.FUNCTION, func))

-- Strings.
local sq_str = lexer.range("'", true)
local dq_str = lexer.range('"', true)
local lq_str = lexer.range('`', true)
lex:add_rule('string', lex:tag(lexer.STRING, sq_str + dq_str + lq_str))

-- Comments.
local line_comment = lexer.to_eol('#', true)
lex:add_rule('comment', lex:tag(lexer.COMMENT, line_comment))

-- Numbers.
lex:add_rule('number', lex:tag(lexer.NUMBER, lexer.number))

-- Identifiers.
lex:add_rule('identifier', lex:tag(lexer.IDENTIFIER, lexer.word))

-- Operators.
lex:add_rule('operator', lex:tag(lexer.OPERATOR, S('+-/*%<>!=^&|?~:;,.()[]{}')))

-- Fold points.
lex:add_fold_point(lexer.COMMENT, '#', '\n')
lex:add_fold_point(lexer.OPERATOR, '{', '}')

-- Word lists.
lex:set_word_list(lexer.KEYWORD, {
  'if', 'else', 'elif', 'then', 'fi', 'while', 'do', 'done', 'for', 'in', 'continue', 'break', 'try', 'except', 'finally', 'return',
  'set', 'use', 'eval', 'exec', 'del', 'is', 'each', 'repeat', 'range',
})

return lex
