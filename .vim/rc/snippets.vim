" Vim configuration: snippets

" Select snippets set                                                  {{{1
" - use honza snippets (installs to vim-snippets/snippets)
let g:neosnippet#disable_runtime_snippets = { '_' : 1 }
if exists('g:neosnippet#snippets_directory')
    unlet g:neosnippet#snippets_directory
endif
let g:neosnippet#snippets_directory = []
call add(g:neosnippet#snippets_directory,
            \ VrcVimPath('home') .
            \ '/repos/github.com/vim-snippets/snippets')

" Key mappings                                                         {{{1
" - <C-k>: expand or jump to next placeholder                          {{{2
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
" - <Tab>: see tab.vim                                                 {{{2

" Marker concealment                                                   {{{1
if has('conceal')
    set conceallevel=2 concealcursor=niv
endif                                                                " }}}1

" vim: set foldmethod=marker :
