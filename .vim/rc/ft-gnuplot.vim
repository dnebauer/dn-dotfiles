" Vim configuration: gnuplot file support

augroup vrc_gnuplot_files
    autocmd!
    " force filetype to 'gnuplot' for syntax support                   {{{1
    autocmd BufRead,BufNewFile *.plt set filetype=gnuplot
                                                                     " }}}1
augroup END

" vim: set foldmethod=marker :
