" Vim configuration: c file support

function! VrcCSupport()
    " mappings                                                         {{{1
    echomsg '-----------------------------------------' |
    echomsg 'You appear to be editing a C source file.' |
    echomsg 'Defining the following mapping(s):'        |
    echomsg '    \m    ->    :make %<    (N,I)'         |
    echomsg '-----------------------------------------' |
    inoremap <Leader>m <Esc>:make %<<CR>
    nnoremap <Leader>m :make %<<CR>
                                                                     " }}}1
endfunction

augroup vrc_c_files
    autocmd!
    " call support function                                            {{{1
    autocmd FileType c call VrcCSupport()
                                                                     " }}}1
augroup END

" vim: set foldmethod=marker :
