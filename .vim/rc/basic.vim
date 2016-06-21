" Vim configuration: basic settings

" Encoding: utf-8                                                      {{{1
set encoding=utf-8

" Language: Australian English                                         {{{1
" - fallback to UK English, then US English, then generic English
" - E197 error means could not set language
try | lang en_AU | catch /^Vim\((\a\+)\)\=:E197:/
    try | lang en_GB | catch /^Vim\((\a\+)\)\=:E197:/
        try | lang en_US | catch /^Vim\((\a\+)\)\=:E197:/
            try | lang en | catch /^Vim\((\a\+)\)\=:E197:/
            endtry
        endtry
    endtry
endtry

" Use ; for :                                                          {{{1
nnoremap ; :
vnoremap ; :

" Disable F1 help key                                                  {{{1
nnoremap <F1> <Nop>
inoremap <F1> <Nop>

" Files to ignore when file matching                                   {{{1
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,
            \.ind,.idx,.ilg,.inx,.out,.toc                           " }}}1

" vim: set foldmethod=marker :