" Vim configuration: python file support

function! s:PythonSupport()
    " vim omnicompletion                                               {{{1
    if has('vim')
        setlocal omnifunc=pythoncomplete#Complete
    endif                                                            " }}}1
endfunction

augroup vrc_python_files
    autocmd!
    autocmd FileType python call s:PythonSupport()
augroup END

" vim: set foldmethod=marker :
