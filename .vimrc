"  STARTING SET UP --------------------------------------------- {{{
set cot+=preview
" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Blink cursor on error instead of beeping (grr)
set visualbell

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

set background=dark "Setting to dark mode
" set background=light "Setting to dark mode

" not entirely sure what this does, need to do some more searching to
" understand what is going on
nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
nnoremap <silent> coh :call gruvbox#hls_toggle()<CR>

nnoremap <leader>* :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
nnoremap <leader>/ :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
nnoremap <leader>? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?

" vim color
" colorscheme gruvbox
colorscheme retrobox
" colorscheme apprentice

" Add numbers to each line on the left-hand side.
set number

" trying to change the cursor when in insert mode vs normal

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Highlight cursor line underneath the cursor vertically.
set cursorcolumn

" Spell check! Did I spell that word right?
" only in the current buffer
:setlocal spell spelllang=en_us

" Use space characters instead of tabs.
set expandtab

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Do not save backup files.
set nobackup

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=3

" Let the lines take on the shape of my window
set wrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" DO I WANT THIS TO BE HERE? 
" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" }}}


" PLUGINS ---------------------------------------------------------------- {{{

"

" Plugin code goes here.
call plug#begin()

Plug 'morhetz/gruvbox'
Plug 'kien/rainbow_parentheses.vim'
Plug 'teague1toast1eater/awesome-vim-colorschemes'
" plugin 'neoclide/coc-java'

call plug#end()
" }}}


" MAPPINGS --------------------------------------------------------------- {{{

" Mappings code goes here.

" This mapping will add a blank line below the current line when enter is pressed
" change to "map <Enter> o<ESC>k" if you want the cursor to not move to the new line when performing this action
map <Enter> o<ESC> 

" This will add a blank line above the cursor when shift + enter is pressed 
" change to "map <Enter> o<ESC>j" if you want the cursor to not move to the
" new line when performing this action
map <S-Enter> O<ESC>


"" " execute the current line of text as a shell command
noremap  Q !!$SHELL<CR>

" date

" fortune philosoraptor

" echo "actual password" | figlet | base64 | base64 -d

"" " execute the current selection as shell commands
vnoremap Q  !$SHELL<CR>

" }}}


" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" More Vimscripts code goes here.

" }}}


" STATUS LINE ------------------------------------------------------------ {{{

" Status bar code goes here.

" }}}

