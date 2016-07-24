" Vim configuration: javascript file support

augroup vrc_javascript_files
    autocmd!
    " call support function
    autocmd FileType javascript call VrcJavascriptSupport()
    " omni completion
    autocmd FileType javascript setlocal
                \ omnifunc=javascriptcomplete#CompleteJS()
augroup END

" vim: set foldmethod=marker :
