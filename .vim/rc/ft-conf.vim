" Vim configuration: conf (configuration) file support

augroup vrc_conf_files
    autocmd!
    " force filetype to 'dosini' for syntax support                    {{{1
    autocmd BufRead,BufNewFile *.conf set filetype=dosini
                                                                     " }}}1
augroup END

" vim: set foldmethod=marker :
