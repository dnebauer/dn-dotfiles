" Vim configuration: syntax checking

" Status line                                                          {{{1
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*                                                   " }}}1

" Location list                                                        {{{1
" - always fill location list with found errors
let g:syntastic_always_populate_loc_list = 1

" Error window                                                         {{{1
" - always display error window when errors are detected
let g:syntastic_auto_loc_list = 1

" When to check                                                        {{{1
" - check for errors on opening, closing and quitting
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0                                      " }}}1

" vim: set foldmethod=marker :
