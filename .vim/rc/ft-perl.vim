" Vim configuration: perl file support

function! VrcPerlSupport()
    " tagbar support                                                   {{{1
    " - from https://github.com/majutsushi/tagbar/wiki
    " - based on ctags settings in ctags config file
    " - ctags config file provided by debian package 'dn-ctags-conf'
    let g:tagbar_type_perl = {
            \ 'ctagstype'  : 'perl',
            \ 'kinds'      : ['a:attribute', 't:subtype', 's:subroutines',
            \                 'c:constants', 'e:extends', 'u:use',
            \                 'r:role'],
            \ 'sro'        : '::',
            \ 'kind2scope' : {},
            \ }                                                      " }}}1
    " omni completion                                                  {{{1
    " - plugin: perlomni.vim
    "let g:neocomplete#sources#omni#input_patterns.perl =
    "            \ '\h\w*->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.perl =
                \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'       " }}}1
endfunction

augroup vrc_perl_files
    autocmd!
    autocmd FileType perl call VrcPerlSupport()
    " template file                                                    {{{1
    if exists('*DNU_InsertTemplate')
        autocmd BufRead *.pl call DNU_InsertTemplate('perlscript')
        autocmd BufRead *.pm call DNU_InsertTemplate('perlmod')
    endif
    if exists('*DNU_LoadTemplate')
        autocmd BufNewFile *.pl call DNU_LoadTemplate('perlscript')
        autocmd BufNewFile *.pm call DNU_LoadTemplate('perlmod')
    endif                                                            " }}}1
augroup END

" vim: set foldmethod=marker :
