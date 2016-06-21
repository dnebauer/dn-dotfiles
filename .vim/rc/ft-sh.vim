" Vim configuration: shell script file support

augroup vrc_shellscript_files
    autocmd!
    " template file                                                    {{{1
    if exists('*DNU_InsertTemplate')
        autocmd BufRead *.sh call DNU_InsertTemplate('shellscript')
    endif
    if exists('*DNU_LoadTemplate')
        autocmd BufNewFile *.sh call DNU_LoadTemplate('shellscript')
    endif                                                            " }}}1
augroup END

" vim: set foldmethod=marker :
