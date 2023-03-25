" Vim Configurations
" ==================

" --- Highlight ---
syntax on
"set cursorline
"set cursorcolumn
let g:loaded_matchparen = 1
" --- end ---


" --- Show info ---
set number
set showcmd
set title

" Status Line
set noruler    " disable "ruler"
set laststatus=2
" To get details, type "help statusline" or see https://vim-jp.org/vimdoc-ja/options.html#'statusline'
set statusline=%m\ %f\ curline:%l,curcol:%v
" --- end ---


" --- Edit Options ---
set expandtab
set tabstop=4
set shiftwidth=4

set smartindent
set autoindent

set textwidth=0

" https://vi.stackexchange.com/questions/2162/why-doesnt-the-backspace-key-work-in-insert-mode
set backspace=indent,eol,start

" [Clipboard]
set clipboard=unnamedplus
" --- end ---


" --- Color Schemes ---
set background=dark

" For syntax highlight in tmux, termguicolors is necessary (Why??)
set termguicolors

colorscheme hybrid
" --- end ---


" --- Misc ---
set writebackup
"set noswapfile
set wrapscan
" --- end ---


" --- Key Mapping ---
" [Complement (ddc)]
"inoremap <Tab> <Cmd>call ddc#map#manual_complete()<CR>
"inoremap <S-Tab> <Cmd>call ddc#map#manual_complete()<CR>
" --- end ---


" --- Plugins (vim-plug) ---
" To install "vim-plug", use feature of "autoload" directory.
" Check $HOME/.vim/autoload/plug.vim, that vim script is main part of "vim-plug".
" Current version: v0.11 (on 2023/3/18)
" vim-plug project: https://github.com/junegunn/vim-plug

call plug#begin('~/.vim/plugged')
"Plug 'davidhalter/jedi-vim', {'for': 'python'}

" [ddc.vim]
" "ddc.vim" consists of 4 main components, 
" "Core", "Sources", "Filters", and "UI".
" - "Core" provides only pure complement features.
" - "Sources" collect complement candidates from around cursor, 
"   file tree, and so on
" - "Filters" filter candidates based on any rules. 
"   The rules vary depending on filter plugins.
" - "UI" provides interface for displaying candidates, selecting a candidate,
"   and so on.
" To get details, please see https://zenn.dev/shougo/articles/ddc-vim-beta.
"
" ddc depends on "deno". To use ddc, you must install "deno".
" See https://deno.land/manual@v1.31.3/getting_started/installation
" 
" Core
Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'

" Sources
Plug 'Shougo/ddc-around'    " collect candidate around cursor position
Plug 'LumaKernel/ddc-file'  " collect candidate from file tree (for complement file path)
" Sources - LSP (Language Server Protocol)
Plug 'shun/ddc-source-vim-lsp'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" Filters
Plug 'Shougo/ddc-matcher_head'  " filter candidates based on typing words
Plug 'Shougo/ddc-sorter_rank'   " sort candidates
Plug 'Shougo/ddc-converter_remove_overlap'  " remove duplication
" UI
Plug 'Shougo/ddc-ui-native'
call plug#end()

" ddc configuration
call ddc#custom#patch_global('ui', 'native')

call ddc#custom#patch_global('sources', [
  \ 'around',
  \ 'file',
  \ 'vim-lsp',
  \])
call ddc#custom#patch_global('sourceOptions', {
  \   '_': {
  \     'matchers': ['matcher_head'],
  \     'sorters': ['sorter_rank'],
  \     'converters': ['converter_remove_overlap'],
  \   },
  \   'around': {
  \     'mark': 'around',
  \   },
  \   'file': {
  \     'mark': 'ddc-file',
  \     'isVolatile': v:true,
  \     'forceCompletionPattern': '\S/\S*',
  \     'ignoreCase': v:false,
  \     'timeout': 2000,
  \   },
  \   'vim-lsp': {
  \     'mark': 'LSP',
  \     'matchers': ['matcher_head'],
  \     'forceCompletionPattern': '\.|:|->|"\w+/*',
  \     'timeout': 2000,
  \   },
  \ })
" Maybe, forceCompletionPattern of vim-lsp relates with complement triger.

call ddc#enable()
" --- end ---


