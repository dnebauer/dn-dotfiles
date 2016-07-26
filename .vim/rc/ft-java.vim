" Vim configuration: java file support

" Completion for deoplete (nvim)
let g:deoplete#omni#input_patterns
            \ = get(g:,'deoplete#omni#input_patterns',{})
let g:deoplete#omni#input_patterns.java = [
            \ '[^. \t0-9]\.\w*',
            \ '[^. \t0-9]\->\w*',
            \ '[^. \t0-9]\::\w*',
            \ ]

" vim: set foldmethod=marker :
