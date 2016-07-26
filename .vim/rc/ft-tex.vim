" Vim configuration: tex file support

" Completion for deoplete (nvim)
let g:deoplete#omni#input_patterns
            \ = get(g:, 'g:deoplete#omni#input_patterns', {})
let g:deoplete#omni#input_patterns.tex = '\v\\%('
            \ . '\a*cite\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
            \ . '|\a*ref%(\s*\{[^}]*|range\s*\{[^,}]*%(}\{)?)'
            \ . '|hyperref\s*\[[^]]*'
            \ . '|includegraphics\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
            \ . '|%(include%(only)?|input)\s*\{[^}]*'
            \ . ')'

" vim: set foldmethod=marker :
