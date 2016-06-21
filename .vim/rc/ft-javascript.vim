" Vim configuration: javascript file support

function! VrcJavascriptSupport()
    " omni completion                                                  {{{1
    autocmd FileType javascript setlocal
                \ omnifunc=javascriptcomplete#CompleteJS
                                                                     " }}}1
endfunction

augroup vrc_javascript_files
    autocmd!
    " call support function                                            {{{1
    autocmd FileType javascript call VrcJavascriptSupport()
                                                                     " }}}1
augroup END

" vim: set foldmethod=marker :
