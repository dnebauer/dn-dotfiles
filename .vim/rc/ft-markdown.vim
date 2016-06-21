" Vim configuration: markdown file support

function! VrcMarkdownSupport()
    " tagbar support                                                   {{{1
    " - from https://github.com/majutsushi/tagbar/wiki
    let l:bin = VrcPluginsDir()
                \ . '/repos/github.com'
                \ . '/jszakmeister/markdown2ctags/markdown2ctags.py'
    if filereadable(l:bin)
        let g:tagbar_type_markdown = {
                    \ 'ctagstype'  : 'markdown',
                    \ 'ctagsbin'   : l:bin,
                    \ 'ctagsargs'  : '-f - --sort=yes',
                    \ 'kinds'      : ['s:sections', 'i:images'],
                    \ 'sro'        : '|',
                    \ 'kind2scope' : {'s' : 'section'},
                    \ 'sort'       : 0,
                    \ }
    endif                                                            " }}}1
    " omni completion                                                  {{{1
    autocmd FileType markdown setlocal
                \ omnifunc=htmlcomplete#CompleteTags
                                                                     " }}}1
endfunction

augroup vrc_markdown_files
    autocmd!
    " call support function                                            {{{1
    autocmd FileType markdown call VrcMarkdownSupport()
                                                                     " }}}1
    " template file                                                    {{{1
    if exists('*DNU_InsertTemplate')
        autocmd BufRead *.md call DNU_InsertTemplate('markdown')
    endif
    if exists('*DNU_LoadTemplate')
        autocmd BufNewFile *.md call DNU_LoadTemplate('markdown')
    endif                                                            " }}}1
    " add system dictionary to word completions                        {{{1
    autocmd FileType text setlocal complete+=k
                                                                     " }}}1
augroup END

" vim: set foldmethod=marker :
