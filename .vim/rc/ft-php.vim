" Vim configuration: php file support

function! s:PHPSupport()
    " tagbar support                                                   {{{1
    " - from https://github.com/vim-php/tagbar-phpctags.vim
    let l:bin = VrcPluginsDir()
                \ . '/repos/github.com'
                \ . '/vim-php/tagbar-phpctags.vim/bin/phpctags'
    if filereadable(l:bin)
        let g:tagbar_phpctags_bin = l:bin
    endif                                                            " }}}1
endfunction

augroup vrc_php_files
    autocmd!
    autocmd FileType php call s:PHPSupport()
augroup END

" vim: set foldmethod=marker :
