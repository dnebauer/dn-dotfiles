" Vim configuration: makefile support

function! VrcMakefileSupport()
    " tagbar support                                                   {{{1
    " - from https://github.com/majutsushi/tagbar/wiki
    " - also edited ~/.ctags to contain 't:target' regex definition:
    "     --regex-make=/^\s*([^#][^:]*):/\1/t,target/
    let g:tagbar_type_make = {
                \ 'kinds': ['m:macros', 't:targets']
                \ }                                                  " }}}1
endfunction

augroup vrc_make_files
    autocmd!
    " call support function                                            {{{1
    autocmd FileType make call VrcMakefileSupport()
                                                                     " }}}1
augroup END

" vim: set foldmethod=marker :
