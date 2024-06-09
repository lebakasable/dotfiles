-- Coq LPeg lexer.

local lexer = lexer
local P, S, B = lpeg.P, lpeg.S, lpeg.B

local lex = lexer.new(...)

-- Keywords.
lex:add_rule('keyword', lex:tag(lexer.KEYWORD, lex:word_match(lexer.KEYWORD)))

-- Types.
local basic_type = lex:tag(lexer.TYPE, lex:word_match(lexer.TYPE))
lex:add_rule('type', basic_type)

-- Functions.
local func = lex:tag(lexer.FUNCTION, lexer.word)
lex:add_rule('function', func * #(lexer.space^0 * '('))

-- Constants.
local const = lex:tag(lexer.CONSTANT_BUILTIN, lex:word_match(lexer.CONSTANT_BUILTIN))
lex:add_rule('constants', const)

-- Strings.
local sq_str = lexer.range("'", true)
local dq_str = lexer.range('"', true)
lex:add_rule('string', lex:tag(lexer.STRING, sq_str + dq_str))

-- Identifiers.
lex:add_rule('identifier', lex:tag(lexer.IDENTIFIER, lexer.word))

-- Comments.
local line_comment = lexer.to_eol('(*', true)
local block_comment = lexer.range('(*', '*)')
lex:add_rule('comment', lex:tag(lexer.COMMENT, line_comment + block_comment))

-- Numbers.
lex:add_rule('number', lex:tag(lexer.NUMBER, lexer.number))

-- Operators.
lex:add_rule('operator', lex:tag(lexer.OPERATOR, S('+-/*%<>!=^&|?~:;,.()[]{}')))

-- Fold points.
lex:add_fold_point(lexer.COMMENT, '(*', '*)')

-- Word lists.
lex:set_word_list(lexer.KEYWORD, {
  'Qed', 'Proof', 'Theorem', 'Lemma', 'Corollary', 'Remark', 'Fact', 'Proposition', 'Definition',
  'Example', 'Fixpoint', 'Inductive', 'CoInductive', 'Record', 'Structure', 'Variant', 'Canonical',
  'Instance', 'Class', 'Existing', 'Variable', 'Variables', 'Hypothesis', 'Hypotheses',
  'Parameter', 'Parameters', 'Axiom', 'Axioms', 'Conjecture', 'Goal', 'Hint', 'Resolve', 'Save',
  'Load', 'Require', 'Import', 'Export', 'Open', 'Close', 'Section', 'Context', 'Module',
  'End', 'Include', 'Proof', 'Ltac', 'match', 'with', 'end', 'as', 'if', 'then', 'else', 'for',
  'exists', 'forall', 'fun', 'let', 'in', 'return', 'fix', 'cofix', 'by', 'do', 'try', 'repeat',
  'constructor', 'elim', 'destruct', 'induction', 'apply', 'eapply', 'case', 'exact', 'left',
  'right', 'split', 'intros', 'intro', 'pattern', 'simpl', 'trivial', 'cbn', 'lazy', 'vm_compute',
  'native_compute', 'reflexivity', 'symmetry', 'transitivity', 'rewrite', 'set', 'pose',
  'assert', 'cut', 'specialize', 'generalize', 'revert', 'rename', 'subst', 'clear', 'replace',
  'injection', 'discriminate', 'inversion', 'dependent', 'setoid_rewrite', 'ring_simplify',
  'field_simplify', 'compute'
})

lex:set_word_list(lexer.TYPE, {
  'Type', 'Prop', 'Set', 'nat', 'bool', 'list', 'option', 'unit'
})

lex:set_word_list(lexer.CONSTANT_BUILTIN, {
  'true', 'false', 'O', 'S', 'Some', 'None', 'nil', 'cons', 'tt'
})

lexer.property['scintillua.comment'] = '(*'

return lex
