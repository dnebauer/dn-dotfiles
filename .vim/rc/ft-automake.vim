" Vim configuration: Makefile.am file support

augroup vrc_automake_files
    autocmd!
    " template file                                                    {{{1
    if exists('*DNU_InsertTemplate')
        autocmd BufRead Makefile.am call DNU_InsertTemplate('makefile.am')
    endif
    if exists('*DNU_LoadTemplate')
        autocmd BufNewFile Makefile.am call DNU_LoadTemplate('makefile.am')
    endif                                                             " }}}
augroup END

" vim: set foldmethod=marker :
