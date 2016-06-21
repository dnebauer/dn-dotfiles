" Vim configuration: html file support

function! VrcHtmlSupport()
    " omni completion                                                  {{{1
    autocmd FileType html setlocal
                \ omnifunc=htmlcomplete#CompleteTags
                                                                     " }}}1
endfunction

augroup vrc_html_files
    autocmd!
    " call support function                                            {{{1
    autocmd FileType html call VrcHtmlSupport()
                                                                     " }}}1
    " template file                                                    {{{1
    if exists('*DNU_InsertTemplate')
        autocmd BufRead *.html call DNU_InsertTemplate('html')
    endif
    if exists('*DNU_LoadTemplate')
        autocmd BufNewFile *.html call DNU_LoadTemplate('html')
    endif                                                            " }}}1
augroup END

" vim: set foldmethod=marker :
