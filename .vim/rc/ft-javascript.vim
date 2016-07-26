" Vim configuration: javascript file support

" Omnicompletion for neocomplete (vim)                                 {{{1
if has('vim')
    augroup vrc_javascript_files
        autocmd!
        " omni completion
        autocmd FileType javascript setlocal
                    \ omnifunc=javascriptcomplete#CompleteJS()
    augroup END
endif

" Completion for deoplete (nvim)                                       {{{1
if has('nvim')
    let g:deoplete#omni#input_patterns
                \ = get(g:, 'deoplete#omni#input_patterns', {})
    let g:deoplete#omni#input_patterns.javascript = '[^. \t]\.\w*'
endif

" vim: set foldmethod=marker :
