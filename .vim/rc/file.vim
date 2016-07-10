" Vim configuration: file exploring

" Ack defaults to using ag if available                                {{{1
if executable('ag')
    let g:ackprg = 'ag --vimgrep --smart-case'
endif                                                                " }}}1

" vim: set foldmethod=marker :
