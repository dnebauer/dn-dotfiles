" Vim configuration: vim (and vimrc) file support

function! VrcVimSupport()
    " syntax checker: set syntastic to use 'vint'                      {{{1
    " - ensure it is installed
    let l:check_cmd = 'python -c "import vint"'
    call system(l:check_cmd)
    if v:shell_error
        let l:install_cmd = 'pip install --upgrade vim-vint'
        let l:feedback = systemlist(l:install_cmd)
        if v:shell_error
            echoerr 'Unable to install vint binary'
            if len(l:feedback)
                echoerr 'Shell feedback:'
                for l:line in l:feedback
                    echoerr '  ' . l:line
                endfor
            endif
        endif
    endif
    call system(l:check_cmd)
    if !v:shell_error
        if !exists('g:syntastic_vim_checkers')
            let g:syntastic_vim_checkers = []
        endif
        if !count(g:syntastic_vim_checkers, 'vint')
            call add(g:syntastic_vim_checkers, 'vint')
        endif
    else
        echoerr "Vim syntax checker 'vint' is not available"
    endif                                                            " }}}1
    " K command: use internal vim help                                 {{{1
    setlocal keywordprg=:help                                        " }}}1
endfunction

augroup vrc_vim_files
    autocmd!
    " call support function                                            {{{1
    autocmd FileType vim call VrcVimSupport()
                                                                     " }}}1
    " reload after changing                                            {{{1
    autocmd BufWritePost .vimrc source $HOME/.vimrc
                                                                     " }}}1
augroup END

" vim: set foldmethod=marker :
