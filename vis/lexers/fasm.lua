-- Copyright 2006-2021 Mitchell. See LICENSE.
-- FASM LPeg lexer.

local lexer = require('lexer')
local token, word_match = lexer.token, lexer.word_match
local P, S = lpeg.P, lpeg.S

local lex = lexer.new('fasm')

-- Whitespace.
lex:add_rule('whitespace', token(lexer.WHITESPACE, lexer.space^1))

-- Labels.
local word = (lexer.alpha + S('$._?')) * (lexer.alnum + S('$._?#@~'))^0
lex:add_rule('label', lex:tag(lexer.LABEL, lexer.starts_line(word * ':')))

lex:add_rule('assignment', lex:tag(lexer.CONSTANT, lexer.word) * lexer.space^1 * lex:tag(lexer.OPERATOR, '='))

-- Types.
lex:add_rule('type', token(lexer.TYPE, word_match[[
  BYTE WORD DWORD QWORD TBYTE OWORD YWORD ZWORD
]]))

-- Registers.
--lex:add_rule('register', token(lexer.CONSTANT, word_match[[
  --rax rbx rcx rdx rsi rdi rbp rsp r8 r9 r10 r11 r12 r13 r14 r15 eax ebx ecx edx esi edi ebp esp r8d r9d r10d r11d r12d r13d r14d r15d ax bx cx dx si di bp sp r8w r9w r10w r11w r12w r13w r14w r15w al ah bl bh cl dl sil dil bpl spl r8b r9b r10b r11b r12b r13b r14b r15b rip eip ip cs ds ss es fs gs fsbase gsbase cr0 cr2 cr3 cr4 cr8 dr0 dr1 dr2 dr3 dr6 dr7 mm0 mm1 mm2 mm3 mm4 mm5 mm6 mm7 xmm0 xmm1 xmm2 xmm3 xmm4 xmm5 xmm6 xmm7 xmm8 xmm9 xmm10 xmm11 xmm12 xmm13 xmm14 xmm15 xmm16 xmm17 xmm18 xmm19 xmm20 xmm21 xmm22 xmm23 xmm24 xmm25 xmm26 xmm27 xmm28 xmm29 xmm30 xmm31 ymm0 ymm1 ymm2 ymm3 ymm4 ymm5 ymm6 ymm7 ymm8 ymm9 ymm10 ymm11 ymm12 ymm13 ymm14 ymm15 ymm16 ymm17 ymm18 ymm19 ymm20 ymm21 ymm22 ymm23 ymm24 ymm25 ymm26 ymm27 ymm28 ymm29 ymm30 ymm31 zmm0 zmm1 zmm2 zmm3 zmm4 zmm5 zmm6 zmm7 zmm8 zmm9 zmm10 zmm11 zmm12 zmm13 zmm14 zmm15 zmm16 zmm17 zmm18 zmm19 zmm20 zmm21 zmm22 zmm23 zmm24 zmm25 zmm26 zmm27 zmm28 zmm29 zmm30 zmm31 k0 k1 k2 k3 k4 k5 k6 k7 st0 st1 st2 st3 st4 st5 st6 st7 bnd0 bnd1 bnd2 bnd3
--]]))

-- Keywords.
lex:add_rule('keyword', token(lexer.KEYWORD, word_match[[
  absolute align assume at clear common define display else elseif end ends entry equ error export extrn file format if import include load local org packed parameter public purge repeat rept restore section segment store struc struct times use while
]]))

-- Instructions.
lex:add_rule('instruction', token(lexer.KEYWORD, word_match[[
  aaa aad aam aas adc add and arpl bb0_reset bndcl bndcn bndcu bndldx bndmk bndmov bndstx bound bsf bsr bswap bt btc btr bts call cbw cdq cdqe clc cld cli clts cmc cmova cmovae cmovb cmovbe cmovc cmove cmovg cmovge cmovl cmovle cmovna cmovnae cmovnb cmovnbe cmovnc cmovne cmovng cmovnge cmovnl cmovnle cmovno cmovnp cmovns cmovnz cmovo cmovp cmovpe cmovpo cmovs cmovz cmp cmpsb cmpsd cmpsq cmpsw cmpxchg cmpxchg16b cmpxchg8b cpuid cwd cwde daa das dec div emms enter f2xm1 fabs fadd faddp fbld fbstp fchs fclex fcmovb fcmovbe fcmove fcmovnb fcmovnbe fcmovne fcmovnu fcmovu fcom fcomi fcomip fcomp fcompp fcos fdecstp fdisi fdiv fdivp fdivr fdivrp femms feni ffree fiadd ficom ficomp fidiv fidivr fild fimul fincstp finit fist fistp fisttp fisub fisubr fld fld1 fldcw fldenv fldl2e fldl2t fldlg2 fldln2 fldpi fldz fmul fmulp fnclex fninit fnop fnsave fnstcw fnstenv fnstsw fpatan fprem fprem1 fptan frndint frstor fsave fscale fsetpm fsin fsincos fsqrt fst fstcw fstenv fstp fstsw fsub fsubp fsubr fsubrp ftst fucom fucomi fucomip fucomp fucompp fwait fxam fxch fxrstor fxsave fxtract fyl2x fyl2xp1 getsec hlt ibts icebp idiv imul in inc insb insd insw int int1 int01 int3 int3e int1e int_ib invd invlpg invlpga iret iretd iretq iretw ja jae jb jbe jc jcxz je jecxz jg jge jl jle jmp jmpe jna jnae jnb jnbe jnc jne jng jnge jnl jnle jno jnp jns jnz jo jp jpe jpo js jz lahf lar lds lea leave les lfence lfs lgdt lgs lidt lldt lmsw loadall loadall286 lodsb lodsd lodsq lodsw loop loope loopne loopnz loopz lsl lss ltr mfence monitor mov movapd movaps movbe movd movddup movdq2q movdqa movdqu movhlps movhpd movhps movlhps movlpd movlps movmskpd movmskps movntdq movntdqa movnti movntpd movntps movntq movq movq2dq movsb movsd movsq movss movsw movsx movsxd movupd movups movzx mul mwait neg nop not or out outsb outsd outsw packssdw packsswb packusdw packuswb paddb paddd paddq paddsb paddsiw paddsw paddusb paddusw paddw pand pandn pause paveb pavgusb pblendvb pblendw pcmpestri pcmpestrm pcmpgtb pcmpgtw pcmpistri pcmpistrm pcmpgt d pdep pext pextrb pextrd pextrq pextrw pf2id pfacc pfadd pfcmpeq pfcmpge pfcmpgt pfmax pfmin pfmul pfnacc pfpnacc pfrcp pfrcpit1 pfrcpit2 pfrsqit1 pfrsqrt pfsub pfsubr phaddd phaddsw phaddw phminposuw phsubd phsubsw phsubw pi2fd pinsrb pinsrd pinsrq pinsrw pmaddwd pmagw pmovmskb pmovsxbd pmovsxbq pmovsxbw pmovsxdq pmovsxwd pmovsxwq pmovzxbd pmovzxbq pmovzxbw pmovzxdq pmovzxwd pmovzxwq pmuldq pmulhrsw pmulhuw pmulhw pmulld pmullw pmuludq pop popa popad popaw popcnt popf popfd popfq popfw prefetch prefetchnta prefetchw prefetchwt1 psadbw pshufb pshufd pshufhw pshuflw pshufw psignb psignd psignw psllq pslld psllw psrad psraw psrld psrlq psrlw psubb psubd psubq psubsb psubsiw psubsw psubusb psubusw psubw ptest punpckhbw punpckhdq punpckhqdq punpckhwd punpcklbw punpckldq punpcklqdq punpcklwd push pusha pushad pushaw pushf pushfd pushfq pushfw pxor rcl rcr rdpmc rdrand rdseed rdpid rdpkru rdpru rdmsr rdpmc rdfsbase rdgsbase rdmsr rdpmc rdtsc rdtscp ret rol ror rorx roundpd roundps roundsd roundss rsm sahf sal salc sar sbb scasb scasd scasq scasw seta setae setb setbe setc sete setg setge setl setle setna setnae setnb setnbe setnc setne setng setnge setnl setnle setno setnp setns setnz seto setp setpe setpo sets setz sfence sgdt shl shld shr shrd sidt sldt sllw slw sldt smsw sqrtps sqrtpd sqrtsd sqrtss stc std stgi sti stmxcsr stosb stosd stosq stosw str sub swapgs syscall sysenter sysexit sysret test ucomisd ucomiss ud2 unpckhpd unpckhps unpcklpd unpcklps verr verw vmcall vmclear vmfunc vmlaunch vmptrld vmptrst vmread vmresume vmrun vmsave vmwrite vmxoff vmxon vpbroadcastb vpbroadcastd vpbroadcastq vpbroadcastw vpcmpeqb vpcmpeqd vpcmpeqq vpcmpeqw vpcmpgtb vpcmpgtd vpcmpgtq vpcmpgtw vpcmpistrm vperm2f128 vpermilpd vpermilps vpermq vpextrb vpextrd vpextrq vpextrw vpgatherdd vpgatherdq vpgatherqd vpgatherqq vphaddd vphaddsw vphaddw vphminposuw vphsubd vphsubsw vphsubw vpinsrb vpinsrd vpinsrq vpinsrw vplzcnt vpmaxsb vpmaxsd vpmaxsq vpmaxsw vpmaxub vpmaxud vpmaxuq vpmaxuw vpminsb vpminsd vpminsq vpminsw vpminub vpminud vpminuq vpminuw vpmaddubsw vpmaddwd vpmaskmovd vpmaskmovq vpmaxsb vpmaxsd vpmaxsq vpmaxsw vpmaxub vpmaxud vpmaxuq vpmaxuw vpminsb vpminsd vpminsq vpminsw vpminub vpminud vpminuq vpminuw vpmovmskb vpmovsxbw vpmovsxbd vpmovsxbq vpmovsxdq vpmovzxwd vpmovzxwq vpmovzxbd vpmovzxbq vpmovzxdq vpmuldq vpmulhrsw vpmulhuw vpmulhw vpmulld vpmullw vpmuludq vpopcntd vpopcntq vpor vpord vpxor vrcpps vrcpss vrsqrtps vrsqrtss vshufpd vshufps vsqrtpd vsqrtps vsqrtsd vsqrtss vstmxcsr vsubpd vsubps vsubsd vsubss vucomisd vucomiss vzeroupper wait wbinvd wrfsbase wrgsbase wrmsr wrpkru wrssd wrssq wrtsc xabort xadd xbegin xchg xend xgetbv xlatb xleave xor xorpd xorps xrstor xrstors xsave xsavec xsaveopt xsaves xsetbv xsha1 xsha256 xstore xtest db dw dd dq dt do dy dz rb rw rd rq rt ro ry rz
]]))

-- Identifiers.
lex:add_rule('identifier', token(lexer.IDENTIFIER, lexer.word))

-- Strings.
local sq_str = lexer.range("'")
local dq_str = lexer.range('"')
lex:add_rule('string', token(lexer.STRING, sq_str + dq_str))

-- Comments.
lex:add_rule('comment', token(lexer.COMMENT, lexer.to_eol(';')))

-- Numbers.
lex:add_rule('number', token(lexer.NUMBER, lexer.number))

-- Operators.
lex:add_rule('operator', token(lexer.OPERATOR, S('+-*/%^=<>,.{}[]()$')))

-- Fold points.
lex:add_fold_point(lexer.COMMENT, lexer.fold_consecutive_lines(';'))

return lex
