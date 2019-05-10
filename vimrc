" options {{{
set tabstop=2
set shiftwidth=2
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
set termguicolors
set smartcase
set updatetime=100
set encoding=utf8
" set guifont=HackNerdFontComplete-Regular:h11
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" }}}

let g:html_indent_inctags = "html,body,head,tbody,script,table,span,tr,td,th,div,p"
let g:python3_host_prog = expand('~/.anyenv/envs/pyenv/versions/neovim/bin/python')
let g:python_host_prog = expand('~/.anyenv/envs/pyenv/versions/neovim/bin/python')

" markdown live viewer {{{
" should markdown preview get shown automatically upon opening markdown buffer
let g:livedown_autorun = 1

" should the browser window pop-up upon previewing
let g:livedown_open = 1

" the port on which Livedown server will run
let g:livedown_port = 1337

" the browser to use
let g:livedown_browser = "google-chrome"
" }}}

" mapping {{{

inoremap jk <esc>
vnoremap jk <esc>
inoremap <esc> <NOP>
inoremap <c-u> <esc>viwUi<esc>A
nnoremap yy 0v$hy
nnoremap j gj
nnoremap k gk
vnoremap <C-C> "+y
" surround with double quotes
vnoremap sdq c"<C-R>""
" surround with double quotes
vnoremap ssq c'<C-R>"'
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
noremap yc gg"+yG
nnoremap oe :Defx `expand('%:p:h')` -search=`expand('%:p')` -split=vertical -winwidth=50 -direction=topleft<CR>

" nvim specific settings
if has("nvim")
  tnoremap <silent> jk <C-\><C-n>
endif
" }}}

"dein Scripts-----------------------------
if !&compatible
  set nocompatible
endif

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

" file explorer settings {{{
nnoremap - :Vexplore<cr>
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
" }}}

" vue setting {{{
autocmd FileType vue syntax sync fromstart
" }}}

" prettier {{{
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync
" }}}

" color scheme {{{
colorscheme vimterial_dark
" }}}

" airline {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='luna'
" }}}

" lsp {{{
if executable('golsp')
  augroup LspGo
    au!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'go-lang',
          \ 'cmd': {server_info->['go-langserver', '-mode', 'stdio']},
          \ 'whitelist': ['go'],
          \ })
    autocmd FileType go setlocal omnifunc=lsp#complete
  augroup END
endif
let g:lsp_async_completion = 1
" }}}


" Automatically creates a directory if it does not exist yet
augroup Mkdir
  autocmd!
  autocmd BufWritePre *
        \ if !isdirectory(expand("<afile>:p:h")) |
        \ call mkdir(expand("<afile>:p:h"), "p") |
        \ endif
augroup END
" }}}

" defx Config: start -----------------
autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
        \ defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> c
        \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
        \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
        \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
        \ defx#do_action('open')
  nnoremap <silent><buffer><expr> E
        \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
        \ defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> K
        \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
        \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> d
        \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
        \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> x
        \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
        \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
        \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> h
        \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
        \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
        \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
        \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
        \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
        \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
        \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
        \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
        \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
        \ defx#do_action('change_vim_cwd')
endfunction

call defx#custom#option('_', {
      \ 'columns': 'indent:git:icons:filename',
      \ })


" defx Config: end -------------------


" Put these lines at the end
filetype plugin indent on
syntax on
