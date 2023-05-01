" Copyright (c) 2023 hogedamari
" Released under the MIT license
" License notice:
" https://github.com/foo2810/quick-vim-configurator/blob/main/LICENSE


" ddc configuration
try
    call ddc#custom#patch_global('ui', 'native')

    call ddc#custom#patch_global('sources', [
      \ 'around',
      \ 'file',
      \ 'nvim-lsp',
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
      \   'nvim-lsp': {
      \     'mark': 'LSP',
      \     'matchers': ['matcher_head'],
      \     'forceCompletionPattern': '\.|:|->|"\w+/*',
      \     'timeout': 2000,
      \   },
      \ })
    " Maybe, forceCompletionPattern of vim-lsp relates with complement triger.

    call ddc#enable()
    " --- end ---
catch /E117.*/
    echo "[Warn] ddc is not installed"
endtry


" denops-popup-preview configuration
try
    call popup_preview#enable()
    inoremap <buffer> <expr><C-J> popup_preview#scroll(+4)
    inoremap <buffer> <expr><C-K> popup_preview#scroll(-4)
    "nnoremap <buffer> <expr><C-J> popup_preview#scroll(+4)
    "nnoremap <buffer> <expr><C-K> popup_preview#scroll(-4)

    " In builtin config, completeopt+=preview is seted.
    " So, when a complement candidate is focused, 
    " another view opens and show candidate's description in the view.
    " It is very obstructive for me...
    set completeopt=menu

catch /E117.*/
    echo "[Warn] denops-popup-preview is not installed"
endtry


" denops-signature_help configuration
try
    call signature_help#enable()
    " if you use with vim-lsp, disable vim-lsp's signature help feature
    let g:lsp_signature_help_enabled = 0
    let g:signature_help_config = {
      \ "contentsStyle": "full",
      \ "viewStyle": "floating"
      \ }
    inoremap <buffer> <expr><C-D> signature_help#scroll(+4)
    inoremap <buffer> <expr><C-U> signature_help#scroll(-4)
catch /E117.*/
    echo "[Warn] denops-signature_help is not installed"
endtry

" [Memo] Newline code
" Linux, UNIX like: LF
" Windows: CR + LF
" MacOS: CR
"
" CF = CTRL + M
" LF = CTRL + J

" [Memo] Tab code
" Tab = CTRL + I (Windows only??)

