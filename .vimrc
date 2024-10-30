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

call plug#begin()

Plug 'catppuccin/vim', { 'as': 'catppuccin' }

Plug 'tpope/vim-vinegar'

call plug#end()

silent! colorscheme catppuccin_mocha
hi Normal guibg=NONE ctermbg=NONE
hi StatusLine guibg=NONE ctermbg=NONE
hi StatusLineNC guibg=NONE ctermbg=NONE
hi CursorLine guibg=NONE ctermbg=NONE

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
