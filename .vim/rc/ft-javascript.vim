" Vim configuration: javascript file support

" Omnicompletion for neocomplete (vim)                                 {{{1
if has('vim')
    augroup vrc_javascript_files
        autocmd!
        " omni completion
        autocmd FileType javascript setlocal
                    \ omnifunc=javascriptcomplete#CompleteJS()
    augroup END
    " these vars suggested on carlitux/deoplete-ternjs github readme
    let g:tern#command   = ["tern"]
    let g:tern#arguments = ["--persistent"]
endif

" Completion for deoplete (nvim)                                       {{{1
if has('nvim')
    let g:deoplete#omni#input_patterns
                \ = get(g:, 'deoplete#omni#input_patterns', {})
    let g:deoplete#omni#input_patterns.javascript = '[^. \t]\.\w*'
    " these vars suggested on carlitux/deoplete-ternjs github readme
    let g:tern_request_timeout       = 1
    let g:tern_show_signature_in_pum = 0  " disable full signature
endif

" vim: set foldmethod=marker :
