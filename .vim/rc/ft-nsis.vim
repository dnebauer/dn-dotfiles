" Vim configuration: nsis file support

augroup vrc_nsis_files
    autocmd!
    " autodetect nsis header files                                     {{{1
    " - vim autodetects nsis script files ('*.nsi') as filetype 'nsis'
    " - vim does not autodetect nsis header files ('*.nsh') filetype
    autocmd BufRead,BufNewFile *.nsh set filetype=nsis
                                                                     " }}}1
augroup END

" vim: set foldmethod=marker :
