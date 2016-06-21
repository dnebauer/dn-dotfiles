" Vim configuration: rc (configuration) file support

augroup vrc_rc_files
    autocmd!
    " template file                                                    {{{1
    if exists('*DNU_InsertTemplate')
        autocmd BufRead *.rc call DNU_InsertTemplate('configfile')
    endif
    if exists('*DNU_LoadTemplate')
        autocmd BufNewFile *.rc call DNU_LoadTemplate('configfile')
    endif                                                            " }}}1
augroup END

" vim: set foldmethod=marker :
