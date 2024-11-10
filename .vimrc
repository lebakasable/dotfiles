syntax on
filetype plugin indent on

set termguicolors
set number
set relativenumber
set shiftwidth=3
set tabstop=3
set expandtab
set smarttab
set scrolloff=8
set fillchars=eob:\ 
set ignorecase
set smartcase
set nowrap
set cursorline
set laststatus=2
set ruler
set undofile
set undodir=~/.vim/undo
set wildmenu
set hlsearch
set incsearch
set ttimeoutlen=10

call plug#begin()

Plug 'catppuccin/vim', { 'as': 'catppuccin' }

Plug 'tpope/vim-vinegar'

Plug 'ziglang/zig.vim'
let g:zig_fmt_autosave = 0

Plug 'shirk/vim-gas'

call plug#end()

silent! colorscheme catppuccin_mocha
hi Normal guibg=NONE ctermbg=NONE
hi StatusLine guibg=NONE ctermbg=NONE
hi StatusLineNC guibg=NONE ctermbg=NONE
hi CursorLine guibg=NONE ctermbg=NONE

command! -nargs=? -range Align <line1>,<line2>call AlignSection('<args>')

nnoremap <silent> <Esc> :noh<CR>

augroup RestoreCursor
   autocmd!
   autocmd BufReadPost *
            \ let line = line("'\"")
            \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
            \      && index(['xxd', 'gitrebase'], &filetype) == -1
            \ |   execute "normal! g`\""
            \ | endif
augroup END

function! AlignSection(regex) range
   let extra = 1
   let sep = empty(a:regex) ? '=' : a:regex
   let maxpos = 0
   let section = getline(a:firstline, a:lastline)
   for line in section
      let pos = match(line, ' *'.sep)
      if maxpos < pos
         let maxpos = pos
      endif
   endfor
   call map(section, 'AlignLine(v:val, sep, maxpos, extra)')
   call setline(a:firstline, section)
endfunction

function! AlignLine(line, sep, maxpos, extra)
   let m = matchlist(a:line, '\(.\{-}\) \{-}\('.a:sep.'.*\)')
   if empty(m)
      return a:line
   endif
   let spaces = repeat(' ', a:maxpos - strlen(m[1]) + a:extra)
   return m[1] . spaces . m[2]
endfunction

autocmd BufRead,BufNewFile *.oak set filetype=oak
autocmd BufRead,BufNewFile *.stas set filetype=stas
