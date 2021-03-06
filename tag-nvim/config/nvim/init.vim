set encoding=utf-8

"""" Plugins
function! PackInit() abort
    packadd minpac

    call minpac#init()
    call minpac#add('k-takata/minpac', {'type': 'opt'})

    call minpac#add('airblade/vim-gitgutter')
    call minpac#add('psf/black')
    call minpac#add('davidhalter/jedi-vim')
    call minpac#add('junegunn/seoul256.vim')
    call minpac#add('sbdchd/neoformat')
    call minpac#add('scrooloose/nerdcommenter')
    call minpac#add('sheerun/vim-polyglot')
    call minpac#add('sjl/gundo.vim')
    call minpac#add('srstevenson/vim-picker')
    call minpac#add('srstevenson/vim-topiary')
    call minpac#add('tpope/vim-abolish')
    call minpac#add('tpope/vim-fugitive')
    call minpac#add('vim-airline/vim-airline')
    call minpac#add('vim-airline/vim-airline-themes')
    call minpac#add('vimwiki/vimwiki')
    call minpac#add('w0rp/ale')

    " autocompletion
    call minpac#add('Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' })
    call minpac#add('Shougo/context_filetype.vim')
    call minpac#add('zchee/deoplete-jedi', { 'do': ':UpdateRemotePlugins' })

endfunction

command! PackUpdate call PackInit() | call minpac#update()
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

"""" Editing
set autoindent
set backspace=2
set diffopt+=vertical
set expandtab
set grepprg=grep\ -nH
set hidden
set inccommand=nosplit
set incsearch
set laststatus=2
set lbr
set list
set listchars=tab:→\ ,trail:·,nbsp:+
set matchtime=2
set scrolloff=5
set shiftwidth=4
set showcmd
set showmatch
set smarttab
set softtabstop=4
set splitright
set tabstop=4
set textwidth=80
set colorcolumn=80
set vb t_vb=

"""" Airline
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
if !exists('g:airline_symbols')
      let g:airline_symbols = {}
endif
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline_powerline_fonts = 1
let g:airline_symbols.space = "\ua0"
let g:airline_theme = 'zenburn'

" Bad whitespace
highlight BadWhitespace ctermbg=237

nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>  " F2 toggles numbers

 autocmd FileType gitcommit,markdown setlocal spell

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

let g:black_virtualenv = '~/.local/venvs/black'
let g:black_linelength = 79

" Use python from neovim virtual environments when not in mizar
let g:loaded_python_provider = 0
let hostname = substitute(system('hostname'), '\n', '', '')
if hostname =~# '^cube-.*'
    let g:python3_host_prog = '/opt/anaconda/envs/Python3/bin/python'
    let g:black_virtualenv = '/opt/anaconda/envs/Python3'
elseif hostname == 'vega'
    let g:python3_host_prog = expand('~/miniconda3/envs/py3/bin/python')
endif

" ALE
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter% - %severity%] %s'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1
" " scalac is *very* slow, ends up using a lot of resources
" au FileType scala let g:ale_lint_on_text_changed = 'never'

" Deoplete

" Use deoplete.

let g:deoplete#enable_at_startup = 1
" call deoplete#custom#option({
"     \ 'smart_case': v:true,
"     \ 'ignore_case': v:true,
"     \ })
" complete with words from any opened file
let g:context_filetype#same_filetypes = {}
let g:context_filetype#same_filetypes._ = '_'

" Jedi-vim

" Disable autocompletion (using deoplete instead)
let g:jedi#completions_enabled = 0

" All these mappings work only for python code:
" Go to definition
let g:jedi#goto_command = ',d'
" Find ocurrences
let g:jedi#usages_command = ',o'
" Find assignments
let g:jedi#goto_assignments_command = ',a'
" Go to definition in new tab
nmap ,D :tab split<CR>:call jedi#goto()<CR>

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

" Display tabs and trailing space in Python mode as bad.
au FileType python match BadWhitespace /^\t\+/
au FileType python match BadWhitespace /\s\+$/

""" Scala ensime
" au FileType scala nnoremap <leader>et :EnTypeCheck<CR>
" au FileType scala nnoremap <leader>ed :EnDeclaration<CR>
" au FileType scala nnoremap <leader>es :EnDeclarationSplit<CR>
" au FileType scala nnoremap <leader>ev :EnDeclarationSplit v<CR>
" scalafmt

autocmd BufWritePre *.{scala,sbt} Neoformat
let g:neoformat_scala_scalafmt = {
            \ 'exe': 'ng',
            \ 'args': ['org.scalafmt.cli.Cli', '--stdin'],
            \ 'stdin': 1,
            \ }

"""" YAML
au FileType yaml set tabstop=2
au FileType yaml set shiftwidth=2
au FileType yaml set softtabstop=2

" Markdown
au BufRead,BufNewFile *.md set filetype=markdown

" Javascript
au FileType javascript
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

nmap <Leader>jp <Plug>(PrettierAsync)
let g:prettier#autoformat = 0
let g:prettier#config#single_quote = 'true'
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#jsx_bracket_same_line = 'false'
let g:prettier#config#arrow_parens = 'avoid'
let g:prettier#config#trailing_comma = 'none'
let g:prettier#config#parser = 'babylon'

"""" Key Mappings
let mapleader=","

nnoremap <tab> %

nnoremap <unique> <leader>gc :Gcommit -v<cr>
nnoremap <unique> <leader>gd :Gdiff<cr>
nnoremap <unique> <leader>gs :Gstatus<cr>
nnoremap <unique> <leader>gw :Gwrite<cr>

nmap <unique> <leader>pe <Plug>(PickerEdit)
nmap <unique> <leader>ps <Plug>(PickerSplit)
nmap <unique> <leader>pt <Plug>(PickerTabedit)
nmap <unique> <leader>pv <Plug>(PickerVsplit)
nmap <unique> <leader>pb <Plug>(PickerBuffer)
nmap <unique> <leader>p] <Plug>(PickerTag)
nmap <unique> <leader>ph <Plug>(PickerHelp)

nnoremap <leader>u :GundoToggle<CR>

nnoremap ; :

nnoremap <leader>q gqip
nnoremap Q gqip

nmap <C-t> :tabnew<CR>
imap <C-t> <Esc>:tabnew<CR>

" Use ag instead of grep
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>
" bind K to grep word under cursor
nnoremap K :Ag <C-R><C-W><CR>

"""" Movement
" work more logically with wrapped lines
noremap j gj
noremap k gk

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

" <space> toggles folds opened and closed
nnoremap <space> za

" <space> in visual mode creates a fold over the marked range
vnoremap <space> zf

" allow arrow keys when code completion window is up
inoremap <Down> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>Down>"<CR>

let g:seoul256_background = 236
colorscheme seoul256

""" MLflow configuration
autocmd BufReadPost */src/github.com/*/mlflow/*.py set colorcolumn=101
autocmd BufReadPost */src/github.com/*/mlflow/*.py let g:ale_python_flake8_options = '--max-line-length=100'
autocmd BufReadPost */src/github.com/dagster-io/*.py set colorcolumn=101
autocmd BufReadPost */src/github.com/dagster-io/*.py let g:ale_python_flake8_options = '--max-line-length=100'

""" vimwiki

let g:vimwiki_list = [{'path': '~/Dropbox/wiki/',
                   \ 'syntax': 'markdown', 'ext': '.md'}]
