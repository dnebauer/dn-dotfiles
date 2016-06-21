" Vim configuration: xquery file support

function! VrcXquerySupport()
    " omni completion                                                  {{{1
    " - plugin: XQuery-indentomnicomplete
    let g:neocomplete#sources#omni#input_patterns.xquery =
                \ '\k\|:\|\-\|&'
    let g:neocomplete#sources#omni#functions.xquery =
                \ 'xquerycomplete#CompleteXQuery'                    " }}}1
endfunction

augroup vrc_xquery_files
    autocmd!
    " call support function                                            {{{1
    autocmd FileType xquery call VrcXquerySupport()
                                                                     " }}}1
augroup END

" vim: set foldmethod=marker :
