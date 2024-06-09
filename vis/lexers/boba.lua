local lexer = require('lexer')
local P, S = lpeg.P, lpeg.S
local C, Cmt = lpeg.C, lpeg.Cmt

local lex = lexer.new(...)

-- Keywords.
lex:add_rule('keyword', lex:tag(lexer.KEYWORD, lex:word_match(lexer.KEYWORD)))

-- Builtin constants.
lex:add_rule('builtin', lex:tag(lexer.CONSTANT, lex:word_match(lexer.CONSTANT)))

-- Strings.
lex:add_rule('string', lex:tag(lexer.STRING, lexer.range('"')))

-- Functions.
lex:add_rule('function', lex:tag(lexer.KEYWORD, P('def')) * lexer.space^1 * lex:tag(lexer.FUNCTION, lexer.any * (lexer.any - P("'") - lexer.space)^0))

-- Identifiers.
lex:add_rule('identifier', lex:tag(lexer.IDENTIFIER, lexer.word))

-- Comments.
--local line_comment = lexer.to_eol('//', true)
--lex:add_rule('comment', lex:tag(lexer.COMMENT, line_comment))

-- Numbers.
lex:add_rule('number', lex:tag(lexer.NUMBER, lexer.number))

-- Keyword list.
lex:set_word_list(lexer.KEYWORD, {
  'if', 'else', '->', 'let', 'with', 'done',
})

-- Builtin constant list.
lex:set_word_list(lexer.CONSTANT, {
  'true', 'false', 'null',
})

return lex
