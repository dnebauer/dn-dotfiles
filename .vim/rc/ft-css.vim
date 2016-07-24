" Vim configuration: css file support

augroup vrc_css_files
    autocmd!
    " omni completion
    autocmd FileType css setlocal
                \ omnifunc=csscomplete#CompleteCSS
augroup END

" vim: set foldmethod=marker :
