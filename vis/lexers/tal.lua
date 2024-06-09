local lexer = require('lexer')
local P, S, R = lpeg.P, lpeg.S, lpeg.R
local C, Cmt = lpeg.C, lpeg.Cmt

local lex = lexer.new(...)

-- Keywords (assuming common Uxn TAL instructions as keywords)
lex:add_rule('keyword', lex:tag(lexer.KEYWORD, lex:word_match(lexer.KEYWORD)))

-- Labels
local label = P('@') * (R("az", "AZ", "09") + P("_") + P("-"))^1
lex:add_rule('label', lex:tag(lexer.LABEL, label))

-- Numbers (decimal and hexadecimal)
local hex_num = P("#") * R("09", "af", "AF")^1
local dec_num = R("09")^1
lex:add_rule('number', lex:tag(lexer.NUMBER, hex_num + dec_num))

-- Comments (single-line comments starting with '--' and multiline comments in parentheses)
local line_comment = lexer.to_eol('--', true)
local block_comment = P('(') * (P(1) - P(')'))^0 * P(')')
lex:add_rule('comment', lex:tag(lexer.COMMENT, line_comment + block_comment))

-- Strings (assuming TAL might use single or double quotes for strings)
local sq_str = lexer.range("'", true)
local dq_str = lexer.range('"')
lex:add_rule('string', lex:tag(lexer.STRING, sq_str + dq_str))

-- Operators (common operators and symbols in TAL)
local operator = S('+-/*%<>@=![]{}()')
lex:add_rule('operator', lex:tag(lexer.OPERATOR, operator))

-- Identifiers (excluding keywords, labels, and operators)
local identifier = (lexer.any - lexer.space)^1 - label - line_comment - block_comment - operator
lex:add_rule('identifier', lex:tag(lexer.IDENTIFIER, identifier))

-- Functions (words starting with ';')
local func = P(';') * (R("az", "AZ") + P("_") + P("-"))^1
lex:add_rule('function', lex:tag(lexer.FUNCTION, func))

-- Fold points (typically based on comments for folding in editors)
lex:add_fold_point(lexer.COMMENT, '--')
lex:add_fold_point(lexer.COMMENT, '(')

-- Keyword list (common TAL instructions, this list can be expanded)
lex:set_word_list(lexer.KEYWORD, {
  'BRK', 'JCI', 'JMI', 'JSI', 'LIT', 'LITr', 'LITr2',
  'INC', 'POP', 'NIP', 'SWP', 'ROT', 'DUP', 'OVR', 'EQU', 'NEQ',
  'GTH', 'LTH', 'JMP', 'JCN', 'JSR', 'STH', 'LDZ', 'STZ', 'LDR',
  'STR', 'LDA', 'STA', 'DEI', 'DEO', 'ADD', 'SUB', 'MUL', 'DIV',
  'AND', 'ORA', 'EOR', 'SFT'
})

-- Optionally, Builtin constants (if TAL uses any specific constants)
lex:set_word_list(lexer.CONSTANT_BUILTIN, {
  'TRUE', 'FALSE', 'NULL'
})

-- Optionally, Types (if TAL defines any specific types)
lex:set_word_list(lexer.TYPE, {
  'int', 'ptr', 'bool', 'addr'
})

lexer.property['scintillua.comment'] = '--'

return lex
