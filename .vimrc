set nocompatible
autocmd Filetype * setlocal formatoptions-=c formatoptions-=r  formatoptions-=o
set encoding=UTF-8
filetype on
set smarttab
set path+=**
filetype plugin on
filetype indent on
syntax on
set number
set mouse=a
set timeout
set ttimeout
set timeoutlen=3000
set ttimeoutlen=50
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
set fillchars=eob:\ 
set termguicolors
colorscheme catppuccin_mocha
set cursorline
set cursorlineopt=number
set shiftwidth=2
set tabstop=2
set nobackup
set incsearch
set hlsearch
set ignorecase
set showcmd
set showmode
set showmatch
set history=1000
set splitbelow splitright
set wildmenu
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set undodir=~/.vim/backup
set undofile
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_showhide=1
let g:netrw_winsize=20
set tags+=/usr/include/**/tags
set omnifunc=syntaxcomplete#Complete
set backspace=indent,eol,start

"inoremap [ []<left>
"inoremap ( ()<left>
"inoremap { {}<left>
"inoremap /* /**/<left><left>

set laststatus=2
set ruler

let mapleader=" "

nnoremap U <c-r>
nnoremap <silent> <esc> :noh<CR>

map <leader>e :Lex<CR>
map <leader>o :Explore<CR>

nnoremap <leader>g :Git<CR>
nnoremap <silent> <leader>t :!ctags -R .<CR>

map <c-t> :ter<CR>
tnoremap <c-t> exit<CR>
tnoremap <c-i> <c-w><s-n>
tnoremap <Esc> <C-\><C-n>

map <leader>y :split<space>
map <leader>x :vsplit<space>

nnoremap <leader>a ggVG
nnoremap <leader>s <cmd>echo "Press a character: " \| let c = nr2char(getchar()) \| exec "normal viwo\ei" . c . "\eea" . c . "\e" \| redraw<CR>
nnoremap <leader>r :%s/\<<c-r><c-w>\>//g<left><left>

vnoremap <a-down> :m '>+1<CR>gv=gv
vnoremap <a-up> :m '>-2<CR>gv=gv

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
