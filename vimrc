" options {{{
set tabstop=4
set shiftwidth=4
set showmatch
set mouse=a
set laststatus=2 
set number
set showtabline=2
set guioptions-=e
set expandtab
set smartindent
set wildmode=longest,list,full
set wildmenu
set noswapfile
set splitbelow
set ambiwidth=double
set backupcopy=yes
set foldmethod=marker
" }}}

let g:html_indent_inctags = "html,body,head,tbody,script,table,span,tr,td,th,div,p"
let g:python3_host_prog = expand('~/.anyenv/envs/pyenv/versions/neovim/bin/python')

" should markdown preview get shown automatically upon opening markdown buffer
let g:livedown_autorun = 1

" should the browser window pop-up upon previewing
let g:livedown_open = 1

" the port on which Livedown server will run
let g:livedown_port = 1337

" the browser to use
let g:livedown_browser = "'google-chrome'"

" mapping {{{

let mapleader = "--"
let maplocalleader = "\\"

inoremap jk <esc>
vnoremap jk <esc>
inoremap <esc> <NOP>
inoremap <c-u> <esc>viwUi<esc>A
nnoremap yy 0v$hy
nnoremap j gj
nnoremap k gk
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>ev :tabe $MYVIMRC<cr>
vnoremap <C-C> "+y
" surround with double quotes
vnoremap sdq c"<C-R>""
" surround with double quotes
vnoremap ssq c'<C-R>"'
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" nvim specific settings
if has("nvim")
  tnoremap <silent> jk <C-\><C-n>
endif
" }}}

"dein Scripts-----------------------------
if !&compatible
  set nocompatible
endif

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" dein settings {{{
" Automatically install dein
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" Read plugins and create cache
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [$MYVIMRC])
  call dein#load_toml(s:toml_file)
  call dein#end()
  call dein#save_state()
endif

" Install missing plugins
if has('vim_starting') && dein#check_install()
  call dein#install()
endif
" }}}

"End dein Scripts-------------------------

" Put these lines at the end
silent! colorscheme molokai
filetype plugin indent on
syntax on
