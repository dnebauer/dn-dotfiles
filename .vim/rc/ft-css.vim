" Vim configuration: css file support

" Omnicompletion for neocomplete (vim)                                 {{{1
if has('vim')
    augroup vrc_css_files
        autocmd!
        autocmd FileType css setlocal
                    \ omnifunc=csscomplete#CompleteCSS
    augroup END
endif

" Completion for deoplete (nvim)                                       {{{1
if has('nvim')
    let g:deoplete#omni#input_patterns
                \ = get(g:, 'deoplete#omni#input_patterns', {})
    let g:deoplete#omni#input_patterns.css
                    \ = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
endif                                                                " }}}1

" vim: set foldmethod=marker :
