" Vim configuration: python file support

augroup vrc_python_files
    autocmd!
    " call support function                                            {{{1
    autocmd FileType python call VrcPythonSupport()
                                                                     " }}}1
    " omni completion                                                  {{{1
    autocmd FileType python setlocal
                \ omnifunc=pythoncomplete#Complete
                                                                     " }}}1
augroup END

" vim: set foldmethod=marker :
