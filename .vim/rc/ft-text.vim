" Vim configuration: text file support

augroup vrc_text_files
    autocmd!
    " add system dictionary to word completions                        {{{1
    au FileType text setlocal complete+=k
                                                                     " }}}1
augroup END

" vim: set foldmethod=marker :
