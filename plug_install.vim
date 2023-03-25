call plug#begin('~/.vim/plugged')
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

