set encoding=utf-8

" vim-plug
call plug#begin()
" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'tpope/vim-rsi'
" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" filesystem
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'

"Plug 'scrooloose/syntastic'
Plug 'neomake/neomake'

" jupyter
Plug 'ivanov/vim-ipython'

" Worksheet
"Plug 'HerringtonDarkholme/vim-worksheet'

" Terminal
Plug 'kassio/neoterm'

" REST console
Plug 'diepm/vim-rest-console'

" Scala
Plug 'derekwyatt/vim-scala'
Plug 'ensime/ensime-vim'

" indent guide
Plug 'nathanaelkane/vim-indent-guides'

" omnicompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'

" folding / indent
Plug 'tmhedberg/SimpylFold'
Plug 'vim-scripts/indentpython.vim'

" tags
Plug 'majutsushi/tagbar'

" latex
Plug 'lervag/vimtex'

"rainbow parens
Plug 'luochen1990/rainbow'

" other 
Plug 'sjl/gundo.vim'
Plug 'junegunn/vim-easy-align'
Plug 'elzr/vim-json'
Plug 'srstevenson/vim-picker'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-abolish'

" colors
Plug 'jnurmine/Zenburn'
Plug 'altercation/vim-colors-solarized'

call plug#end()

" Set filetype on
filetype plugin on
filetype indent on
let python_highlight_all=1
syntax on
set modelines=0

" persistent undo
set undofile
" set undodir=~/.vim/undodir
set undolevels=10000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

"Set backups and swap files outside working dir
set backupdir=~/.backup//,.,/tmp//
set directory=~/.backup//,.,/tmp//

" we don't want to edit these type of files
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.swp
set wildmode=longest,list,full
set wildmenu

"""" Editing
set backspace=2           " Backspace over anything! (Super backspace!)
set showmatch             " Briefly jump to the previous matching paren
set matchtime=2           " For .2 seconds
set tabstop=4             " Tab stop of 4
set shiftwidth=4          " sw 4 spaces (used on auto indent)
set softtabstop=4         " 4 spaces as a tab for bs/del
set expandtab
set smarttab
set autoindent
"set smartindent

"""" Messages, Info, Status
set shortmess+=a         " Use [+] [RO] [w] for modified, read-only, modified
set showcmd              " Display what command is waiting for an operator
set laststatus=2         " Always show statusline, even if only 1 window
set report=0             " Notify me whenever any lines have changed
set confirm              " Y-N-C prompt if closing with unsaved changes
set vb t_vb=             " Disable visual bell!  I hate that flashing.
set statusline=%<%f%m%r%y%=%b\ 0x%B\ \ %l,%c%V\ %P
set cursorline

set grepprg=grep\ -nH\ $*

set lbr
set textwidth=80
set nu
set splitright

"""" Airline
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
      let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline_theme = 'zenburn'

" Bad whitespace
highlight BadWhitespace ctermbg=237

"""" Folding
set foldmethod=syntax    " By default, use syntax to determine folds
set foldlevelstart=99    " All folds open by default

"""" Searching and Patterns
set ignorecase       " search is case insensitive
set smartcase        " search case sensitive if caps on 
set incsearch        " show best match so far
set hlsearch         " Highlight matches to the search 
set showmatch
" remove highlight for previous search results
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

"""" Display
" set background=dark           " I use dark background
set lazyredraw                " Don't repaint when scripts are running
set scrolloff=4               " Keep 3 lines below and above the cursor
set ruler                     " line numbers and column the cursor is on
set nonumber                    " Show line numbering
set numberwidth=1             " Use 1 col + 1 space for numbers
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>  " F2 toggles numbers
set pastetoggle=<f6>
set list
"set listchars=tab:▸\ ,eol:¬

" Comments
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 0
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

" tab labels show the filename without path(tail)
set guitablabel=%N/\ %t\ %M

" Use python from neovim virtual environments
let g:python_host_prog = expand('~/virtualenvs/neovim2/bin/python')
let g:python3_host_prog = expand('~/virtualenvs/neovim3/bin/python')

" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:deoplete#omni#input_patterns = {}
let g:deoplete#omni#input_patterns.scala = [
\ '[^. *\t]\.\w*', '[:\[,] ?\w*', '^import .*']
"let g:deoplete#disable_auto_complete = 1
"if has("gui_running")
    "inoremap <silent><expr><C-Space> deoplete#mappings#manual_complete()
"else
    "inoremap <silent><expr><C-@> deoplete#mappings#manual_complete()
"endif

" UltiSnips
inoremap <silent><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" NeoTerm
nnoremap <silent> <leader>tf :TREPLSendFile<cr>
nnoremap <silent> <leader>ts :TREPLSendLine<cr>
vnoremap <silent> <leader>ts :TREPLSendSelection<cr>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"""" Python
"autocmd FileType python set complete+=k~/.vim/syntax/python.vim isk+=.,(
map <buffer> <S-e> :w<CR>:!/usr/bin/env python % <CR>
autocmd FileType python set formatoptions-=tc
"autocmd FileType python set omnifunc=pythoncomplete#Complete

au FileType python 
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |

au FileType python map <silent> <leader>b oimport pdb; pdb.set_trace()<esc>
au FileType python map <silent> <leader>B Oimport pdb; pdb.set_trace()<esc>

autocmd FileType python nnoremap <leader>y :0,$!yapf --style google<CR>

" Display tabs at the beginning of a line in Python mode as bad.
au FileType python match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au FileType python match BadWhitespace /\s\+$/
"

"python with virtualenv support
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  sys.path.insert(0, project_base_dir)
  activate_this = os.path.join(project_base_dir,'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF


""" Scala
au FileType scala
    \ if executable('scala') |
    \   call neoterm#repl#set('scala') |
    \ end

"""" YAML
autocmd FileType yaml set tabstop=2
autocmd FileType yaml set shiftwidth=2  
autocmd FileType yaml set softtabstop=2 

"""" tf
autocmd FileType tf set tabstop=2
autocmd FileType tf set shiftwidth=2  
autocmd FileType tf set softtabstop=2 

" Fortran
let fortran_do_enddo=1

" Markdown
au BufRead,BufNewFile *.md set filetype=markdown

" Change title of terminal to current buffer
autocmd BufEnter * let &titlestring = "vim - " . expand("%:t") 
set title

" Neomake
autocmd! BufWritePost,BufEnter,InsertLeave * Neomake
let g:neomake_python_enabled_makers = ['flake8']

let g:neomake_error_sign = { 'text': 'E>', 'texthl': 'ErrorMsg' }
let g:neomake_warning_sign = { 'text': 'W>', 'texthl': 'WarningMsg' }

"let g:neomake_open_list = 2

"""" Key Mappings
let mapleader=","
" bind ctrl+space for omnicompletion

" File picker
nnoremap <silent> <leader>e :PickerEdit<cr>
nnoremap <silent> <leader>s :PickerSplit<cr>
nnoremap <silent> <leader>t :PickerTabedit<cr>
nnoremap <silent> <leader>v :PickerVsplit<cr>

nnoremap <leader>u :GundoToggle<CR>
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
inoremap jj <ESC>

nnoremap ; :
if has('mac')
    inoremap £ #
    inoremap # £
endif
"au FocusLost * :wa

nnoremap <leader>q gqip
nnoremap Q gqip

nmap <C-t> :tabnew<CR>
imap <C-t> <Esc>:tabnew<CR>

"""" Movement
" work more logically with wrapped lines
noremap j gj
noremap k gk

"reselect the text that was just pasted
"nnoremap <leader>v V`] 
"vertical split
nnoremap <leader>w <C-w>v<C-w>l 


" Toggle the tag list bar
nmap <F4> :TlistToggle<CR>
nmap <F3> :NERDTreeToggle<CR>

if &diff
" easily handle diffing 
   vnoremap < :diffget<CR>
   vnoremap > :diffput<CR>
else
" visual shifting (builtin-repeat)
   vnoremap < <gv                       
   vnoremap > >gv 
endif

" <C-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" * and # search for next/previous of selected text when used in visual mode
vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>

" <space> toggles folds opened and closed
nnoremap <space> za

" <space> in visual mode creates a fold over the marked range
vnoremap <space> zf

" allow arrow keys when code completion window is up
inoremap <Down> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>Down>"<CR>

""" Abbreviations
function! EatChar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunc

if has('gui_running')
    set background=dark
    colorscheme solarized
else
    set t_Co=256
    colorscheme zenburn
endif
execute "set colorcolumn=" . join(map(range(2,259),'"+".v:val'), ',')
hi ColorColumn ctermbg=238

" Indent Guide
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=238
hi IndentGuidesEven ctermbg=237
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

" Rainbow Parens
let g:rainbow_active = 0
nmap <leader>r :RainbowToggle<CR>

" Tagbar
nmap <F8> :TagbarToggle<CR>

if ! has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif

" Transparent editing of gpg encrypted files.
augroup encrypted
au!
" First make sure nothing is written to ~/.viminfo while editing
" an encrypted file.
autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
" We don't want a swap file, as it writes unencrypted data to disk
autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
" Switch to binary mode to read the encrypted file
autocmd BufReadPre,FileReadPre      *.gpg set bin
autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
autocmd BufReadPre,FileReadPre      *.gpg let shsave=&sh
autocmd BufReadPre,FileReadPre      *.gpg let &sh='sh'
autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt --default-recipient-self 2> /dev/null
autocmd BufReadPost,FileReadPost    *.gpg let &sh=shsave
" Switch to normal mode for editing
autocmd BufReadPost,FileReadPost    *.gpg set nobin
autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")
" Convert all text to encrypted text before writing
autocmd BufWritePre,FileWritePre    *.gpg set bin
autocmd BufWritePre,FileWritePre    *.gpg let shsave=&sh
autocmd BufWritePre,FileWritePre    *.gpg let &sh='sh'
autocmd BufWritePre,FileWritePre    *.gpg '[,']!gpg -c 2>/dev/null
autocmd BufWritePre,FileWritePre    *.gpg let &sh=shsave
" Undo the encryption so we are back in the normal text, directly
" after the file has been written.
autocmd BufWritePost,FileWritePost  *.gpg silent u
autocmd BufWritePost,FileWritePost  *.gpg set nobin
augroup END
