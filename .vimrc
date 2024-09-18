set nocompatible
autocmd Filetype * setlocal formatoptions-=c formatoptions-=r  formatoptions-=o
set encoding=UTF-8
filetype on
set expandtab
set smarttab
set shell=sh
filetype plugin on
filetype indent on
syntax on

call plug#begin()

Plug 'morhetz/gruvbox'
Plug 'tpope/vim-commentary'
Plug 'mg979/vim-visual-multi'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ziglang/zig.vim'
let g:hare_recommended_style = 0
Plug 'https://git.sr.ht/~sircmpwn/hare.vim'
Plug 'krischik/vim-ada'
Plug 'fatih/vim-go'
Plug 'ollykel/v-vim'
let g:pascal_delphi=1
Plug 'caglartoklu/fbc.vim'

call plug#end()

set number
set relativenumber
set mouse=a
set timeout
set ttimeout
set timeoutlen=3000
set ttimeoutlen=50
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
set fillchars=eob:\ 
set termguicolors
set background=dark
colorscheme gruvbox
set cursorline
set cursorlineopt=number
set shiftwidth=3
set tabstop=3
set nobackup
set incsearch
set hlsearch
set showcmd
set showmode
set showmatch
set history=1000
set splitbelow splitright
set wildmenu
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set undodir=~/.vim/backup
set undofile
set directory=~/.vim/swap
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_showhide=1
let g:netrw_winsize=20
"set tags+=/usr/include/**/tags
set omnifunc=syntaxcomplete#Complete
set backspace=indent,eol,start
set scrolloff=8
set autoindent
set laststatus=2
set ruler
set linebreak

let mapleader=" "

nnoremap <silent> <esc> :noh<CR>
nnoremap <silent> <tab> :bn<CR>
nnoremap <silent> <s-tab> :bp<CR>

map <silent> <leader>f :Files<CR>
map <silent> <leader>b :Buffers<CR>
map <silent> <leader>l :Lines<CR>

map <silent> <leader>e :Lex<CR>
map <silent> <leader>o :Explore<CR>

nnoremap <silent> <leader>g :Git<CR>
nnoremap <silent> <leader>t :!ctags -R .<CR>

map <silent> <leader>y :split<CR>
map <silent> <leader>x :vsplit<CR>

nnoremap <leader>a ggVG
nnoremap <leader>s <cmd>echo "Press a character: " \| let c = nr2char(getchar()) \| exec "normal viwo\ei" . c . "\eea" . c . "\e" \| redraw<CR>
nnoremap <leader>r :%s/\<<c-r><c-w>\>//g<left><left>

vnoremap <a-down> :m '>+1<CR>gv=gv
vnoremap <a-up> :m '>-2<CR>gv=gv

nnoremap <down> gj
nnoremap <up> gk
vnoremap <down> gj
vnoremap <up> gk
inoremap <down> <C-o>gj
inoremap <up> <C-o>gk
nnoremap $ g$
nnoremap 0 g0
vnoremap $ g$
vnoremap 0 g0

function! LastCursorPosition()
  if line("'\"") > 0 && line("'\"") <= line("$")
    exe "normal! g`\""
  endif
endfunction

augroup last_cursor_position
  autocmd!
  autocmd BufReadPost * call LastCursorPosition()
augroup END

autocmd FileType html nnoremap <buffer> ,html5 :-1read ~/.vim/snippets/html/html5.html<CR>5j3wa
autocmd FileType haskell nnoremap <buffer> ,main :-1read ~/.vim/snippets/haskell/main.hs<CR>
autocmd FileType python nnoremap <buffer> ,main :-1read ~/.vim/snippets/python/main.py<CR>
autocmd FileType c nnoremap <buffer> ,main :-1read ~/.vim/snippets/c/main.c<CR>
autocmd BufRead,BufNewFile LICENSE nnoremap <buffer> ,mit :-1read ~/.vim/snippets/license/mit<CR>

nnoremap <leader>m :make! 
autocmd QuickFixCmdPost [^l]* cwindow
autocmd QuickFixCmdPost l* cclose

autocmd BufNewFile,BufRead *.adb,*.ads,*.gpr let &makeprg='./build.sh'
"autocmd BufNewFile,BufRead *.pas let &makeprg='./build.sh'
autocmd BufNewFile,BufRead *.pas compiler fpc
autocmd BufNewFile,BufRead *.pas syn match Comment /\/\/.*/
autocmd BufNewFile,BufRead *.bas compiler fbc
autocmd BufNewFile,BufRead *.bas setf freebasic

autocmd BufRead,BufNewFile *.duk set filetype=duk
