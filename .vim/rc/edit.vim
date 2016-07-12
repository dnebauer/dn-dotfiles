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

" Undo                                                            {{{1
nnoremap <Leader>u :GundoToggle<CR>

" Delete trailing whitespace                                      {{{1
let g:DeleteTrailingWhitespace        = 1
let g:DeleteTrailingWhitespace_Action = 'delete'

" Move visual block up and down : J,K                             {{{1
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Cycle through visual modes : v                                  {{{1
xnoremap <expr> v mode() ==# 'v' ? "\<C-V>"
            \                    : mode() ==# 'V'
            \                        ? 'v'
            \                        : 'V'
                                                                " }}}1

" vim: set foldmethod=marker :
