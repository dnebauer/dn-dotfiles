" Vim configuration: css file support

function! VrcCssSupport()
    " omni completion                                                  {{{1
    autocmd FileType css setlocal
                \ omnifunc=csscomplete#CompleteCSS
                                                                     " }}}1
endfunction

augroup vrc_css_files
    autocmd!
    " call support function                                            {{{1
    autocmd FileType css call VrcCssSupport()
                                                                     " }}}1
augroup END

" vim: set foldmethod=marker :
