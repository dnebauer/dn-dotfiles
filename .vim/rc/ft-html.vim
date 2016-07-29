" Vim configuration: html file support

function! s:HtmlSupport()
    " vim-specific omnicompletion                                      {{{1
    if has('vim')
        setlocal omnifunc=htmlcomplete#CompleteTags
    endif                                                            " }}}1
endfunction

augroup vrc_html_files
    autocmd!
    " template file                                                    {{{1
    if exists('*DNU_InsertTemplate')
        autocmd BufRead *.html call DNU_InsertTemplate('html')
    endif
    if exists('*DNU_LoadTemplate')
        autocmd BufNewFile *.html call DNU_LoadTemplate('html')
    endif                                                            " }}}1
    autocmd FileType html call s:HtmlSupport()
augroup END

" vim: set foldmethod=marker :
