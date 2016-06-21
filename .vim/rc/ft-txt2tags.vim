" Vim configuration: txt2tags file support

augroup vrc_txt2tags_files
    autocmd!
    " force filetype to 'txt2tags' for syntax support                  {{{1
    autocmd BufRead,BufNewFile *.t2t set filetype=txt2tags
                                                                     " }}}1
augroup END

" vim: set foldmethod=marker :
