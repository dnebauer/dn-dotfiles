" Vim configuration: deoplete plugin

" Nvim only                                                            {{{1
if !has('nvim')
    finish
endif

" Smartcase                                                            {{{1
let g:deoplete#enable_smart_case  = 1

" Close parentheses automatically                                      {{{1
let g:neopairs#enable = 1

" Keywords                                                             {{{1
" - default
let g:deoplete#keyword_patterns
            \ = get(g:, 'deoplete#keyword_patterns', {})
if empty(g:deoplete#keyword_patterns)
            \ && exists('g:deoplete#_keyword_patterns')
    let g:deoplete#keyword_patterns = g:deoplete#_keyword_patterns
endif

" Key mappings                                                         {{{1
" - <Tab>: see tab.vim                                                 {{{2

" - <CR> : close popup and save indent                                  {{{2
inoremap <silent> <CR> <C-r>=<SID>Deoplete_CR()<CR>
function! s:Deoplete_CR()
    return deoplete#close_popup() . "\<CR>"
endfunction

" - <C-l>: refresh copmletion candidates                               {{{2
inoremap <expr><C-l> deoplete#refresh()

" - <BS> : close popup and delete backword char                        {{{2
"   . in deoplete these conflict with endwise, so disable
"inoremap <expr><C-h>
"            \ deoplete#mappings#smart_close_popup()."\<C-h>"
"inoremap <expr><BS>
"            \ deoplete#mappings#smart_close_popup()."\<C-h>"

" - <C-g>: undo completion                                             {{{2
inoremap <expr><C-g> deoplete#undo_completion()

" Omni completion                                                      {{{1
" - the variables g:deoplete#omni_patterns and
"   g:deoplete#omni#input_patterns have similar purposes
" - plugin author states the differences in
"   https://github.com/Shougo/deoplete.nvim/issues/190
" - g:deoplete#omni_patterns:
"     'It is called by Vim.'
"     'Full compatibility. But you cannot [use] deoplete features.'
"     'It is provided for old omnifunc compatibility.'
"     'You should not use this feature if you can avoid.'
"     'It is Vim script regex.'
" - g:deoplete#omni#input_patterns:
"     'It is called by omni source.'
"     'It is faster and integrated to deoplete.'
"     'But it does not support some of omnifunc.'
"     'It is Python3 regex.'
" - so, prefer g:deoplete#omni#input_patterns
if !exists('g:deoplete#omni_patterns')
    let g:deoplete#omni_patterns = {}
endif

" Input patterns                                                       {{{1
" - default
let g:deoplete#omni#input_patterns
            \ = get(g:,'deoplete#omni#input_patterns',{})

" Sources                                                              {{{1
" - default
let g:deoplete#sources   = get(g:, 'deoplete#sources', {})
let g:deoplete#sources._ = ['buffer', 'tag']

" Filetype-specific completion                                         {{{1
" - see ft-filetype.vim configuration files                            }}}1

" vim: set foldmethod=marker :