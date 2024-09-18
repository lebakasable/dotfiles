local lexer = require('lexer')
local P, S = lpeg.P, lpeg.S
local C, Cmt = lpeg.C, lpeg.Cmt

local lex = lexer.new(...)

local keyword = lex:tag(lexer.KEYWORD, lex:word_match(lexer.KEYWORD))
local funct = lex:tag(lexer.FUNCTION, lexer.word)
lex:add_rule('keyword', keyword)
lex:add_rule('function', lex:tag(lexer.DEFAULT, P'(') * lexer.space^0 * (keyword + funct))

local str = lexer.range('"')
local chr = P'`' * P'\\'^-1 * lexer.any * P'`'
lex:add_rule('string', lex:tag(lexer.STRING, str + chr))
lex:add_rule('number', lex:tag(lexer.NUMBER, lexer.number))

local symbol = S"':" * lexer.word
lex:add_rule('constant', lex:tag(lexer.CONSTANT, symbol))

lex:add_rule('identifier', lex:tag(lexer.IDENTIFIER, lexer.word))

local line_comment = lexer.to_eol(';', true)
lex:add_rule('comment', lex:tag(lexer.COMMENT, line_comment))

lex:add_fold_point(lexer.COMMENT, ';')

lex:set_word_list(lexer.KEYWORD, {
  'Where', 'Define', 'Let', 'In', 'Iterate', 'Match', 'Continue', 'Func', 'If', 'True', 'False', 'Cond', 'Package', 'Block', 'Unfold', 'Begin', 'When', 'Prefix', 'Infix', 'Pattern', 'Matches', 'Open', 'From', 'Fold', 'Reduce', 'Prim', 'And', 'Or',
})

lexer.property['scintillua.comment'] = ';'

return lex
