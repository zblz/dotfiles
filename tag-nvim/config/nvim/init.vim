set encoding=utf-8

call plug#begin()

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'airblade/vim-gitgutter'
Plug 'derekwyatt/vim-scala'
Plug 'diepm/vim-rest-console'
Plug 'dojoteef/neomake-autolint'
Plug 'elzr/vim-json'
Plug 'ensime/ensime-vim', { 'do': ':UpdateRemotePlugins' }
Plug 'jnurmine/Zenburn'
Plug 'junegunn/vim-easy-align'
Plug 'kassio/neoterm'
Plug 'luochen1990/rainbow'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'neomake/neomake'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'sjl/gundo.vim'
Plug 'srstevenson/vim-picker'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'zchee/deoplete-jedi'

call plug#end()

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

set inccommand=nosplit
set diffopt+=vertical

set showcmd              " Display what command is waiting for an operator
set laststatus=2         " Always show statusline, even if only 1 window
set vb t_vb=             " Disable visual bell!  I hate that flashing.

set grepprg=grep\ -nH\ $*

set lbr
set textwidth=80
set number
set splitright

set incsearch        " show best match so far
set scrolloff=5               " Keep 3 lines below and above the cursor
set listchars=tab:→\ ,trail:·,nbsp:+

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

nnoremap <leader><space> :noh<cr>

nnoremap <tab> %
vnoremap <tab> %

"""" Display
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>  " F2 toggles numbers

" Comments
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
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

" NeoTerm
nnoremap <silent> <leader>tf :TREPLSendFile<cr>
nnoremap <silent> <leader>ts :TREPLSendLine<cr>
vnoremap <silent> <leader>ts :TREPLSendSelection<cr>

" Start interactive EasyAlign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

au FileType python
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set formatoptions-=tc

au FileType python map <silent> <leader>b oimport pdb; pdb.set_trace()<esc>
au FileType python map <silent> <leader>B Oimport pdb; pdb.set_trace()<esc>

autocmd FileType python nnoremap <leader>y :0,$!yapf --style google<CR>

" Display tabs at the beginning of a line in Python mode as bad.
au FileType python match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au FileType python match BadWhitespace /\s\+$/
"

" python with virtualenv support
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
autocmd BufWritePost *.scala silent! :EnTypeCheck
au FileType scala nnoremap <leader>et :EnTypeCheck<CR>
au FileType scala nnoremap <leader>ed :EnDeclaration<CR>
au FileType scala nnoremap <leader>es :EnDeclarationSplit<CR>
au FileType scala nnoremap <leader>ev :EnDeclarationSplit v<CR>

"""" YAML
au FileType yaml set tabstop=2
au FileType yaml set shiftwidth=2
au FileType yaml set softtabstop=2

" Markdown
au BufRead,BufNewFile *.md set filetype=markdown

" Neomake
autocmd! BufWritePost,BufEnter,InsertLeave * Neomake
let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_scala_enabled_makers = ['scalac']

let g:neomake_error_sign = { 'text': 'E>', 'texthl': 'ErrorMsg' }
let g:neomake_warning_sign = { 'text': 'W>', 'texthl': 'WarningMsg' }

"""" Key Mappings
let mapleader=","

nnoremap <unique> <leader>gc :Gcommit -v<cr>
nnoremap <unique> <leader>gd :Gdiff<cr>
nnoremap <unique> <leader>gs :Gstatus<cr>
nnoremap <unique> <leader>gw :Gwrite<cr>

" File picker
" nnoremap <silent> <leader>e :PickerEdit<cr>
" nnoremap <silent> <leader>s :PickerSplit<cr>
" nnoremap <silent> <leader>t :PickerTabedit<cr>
" nnoremap <silent> <leader>v :PickerVsplit<cr>
nmap <unique> <leader>pe <Plug>PickerEdit
nmap <unique> <leader>ps <Plug>PickerSplit
nmap <unique> <leader>pt <Plug>PickerTabedit
nmap <unique> <leader>pv <Plug>PickerVsplit
nmap <unique> <leader>pb <Plug>PickerBuffer
nmap <unique> <leader>p] <Plug>PickerTag
nmap <unique> <leader>ph <Plug>PickerHelp

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

nnoremap <leader>q gqip
nnoremap Q gqip

nmap <C-t> :tabnew<CR>
imap <C-t> <Esc>:tabnew<CR>

"""" Movement
" work more logically with wrapped lines
noremap j gj
noremap k gk

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

set t_Co=256
colorscheme zenburn
set colorcolumn=80
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
