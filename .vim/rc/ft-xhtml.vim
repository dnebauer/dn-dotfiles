" Vim configuration: xhtml file support

augroup vrc_xhtml_files
    autocmd!
    " template file                                                    {{{1
    if exists('*DNU_InsertTemplate')
        autocmd BufRead *.xhtml call DNU_InsertTemplate('xhtml')
    endif
    if exists('*DNU_LoadTemplate')
        autocmd BufNewFile *.xhtml call DNU_LoadTemplate('xhtml')
    endif                                                            " }}}1
augroup END

" vim: set foldmethod=marker :
