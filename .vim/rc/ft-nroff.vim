" Vim configuration: manpage file support

augroup vrc_nroff_files
    autocmd!
    " template file                                                    {{{1
    if exists('*DNU_InsertTemplate')
        autocmd BufRead *.[0-9] call DNU_InsertTemplate('manpage')
    endif
    if exists('*DNU_LoadTemplate')
        autocmd BufNewFile *.[0-9] call DNU_LoadTemplate('manpage')
    endif                                                            " }}}1
augroup END

" vim: set foldmethod=marker :
