" Vim configuration: desktop file support

augroup vrc_desktop_files
    autocmd!
    " template file                                                    {{{1
    if exists('*DNU_InsertTemplate')
        autocmd BufRead *.rc call DNU_InsertTemplate('desktop')
    endif
    if exists('*DNU_LoadTemplate')
        autocmd BufNewFile *.rc call DNU_LoadTemplate('desktop')
    endif                                                            " }}}1
augroup END

" vim: set foldmethod=marker :
