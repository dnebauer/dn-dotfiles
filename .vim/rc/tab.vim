" Vim configuration: tab behaviour

function! s:TabComplete()

    " is completion menu open? cycle to next item
    if pumvisible()
        return "\<C-n>"
    endif

    " is there a snippet that can be expanded?
    " is there a placholder inside the snippet that can be jumped to?
    if neosnippet#expandable_or_jumpable()
        return "\<Plug>(neosnippet_expand_or_jump)"
    endif

    " if none of these match just use regular tab
    return "\<Tab>"

endfunction

inoremap <silent><expr><TAB> <SID>TabComplete()

" vim: set foldmethod=marker :
