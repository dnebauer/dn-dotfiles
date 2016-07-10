" Vim configuration: editing

" Clipboard                                                            {{{1
" - all yanked, deleted, changed and pasted text is
"   put into the system clipboard and can be pasted
"   into another vim instance using a vim paste
"   ('unnamed')
" - any visually selected text in vim, or globally-
"   selected text in the windowing system, can be
"   pasted in any vim instance using the windowing
"   system's mechanism; and vice versa in that
"   visually selected text in vim can be pasted into
"   any other application in the windowing system;
"   in X that means any mouse-selected text in any
"   application can be pasted into vim using a
"   mousewheel click or a vim paste, and vice versa
"   ('autoselect')
if !has('nvim')
    set clipboard=unnamed,autoselect
endif

" Toggle paste : F2                                               {{{1
set pastetoggle=<F2>

" Commenting                                                      {{{1
" - add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" - allow commenting and inverting empty lines
let g:NERDCommentEmptyLines = 1
" - enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Undo
nnoremap <Leader>u :GundoToggle<CR>
                                                                " }}}1

" vim: set foldmethod=marker :