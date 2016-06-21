" Vim configuration: reportbug file support

augroup vrc_reportbug_files
    autocmd!
    " set filetype                                                     {{{1
    " - the debian bug reporting mechanism generates files with the
    "   name stem 'reportbug' which are not given colour syntax
    " - setting filetype to 'mail' works adequately
    autocmd BufRead reportbug.*,reportbug-* set filetype=mail
                                                                     " }}}1
augroup END

" vim: set foldmethod=marker :
