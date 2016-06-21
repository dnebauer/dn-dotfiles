" Vim configuration: xml file support

function! VrcXMLSupport()
    " fold by syntax                                                   {{{1
    setlocal foldmethod=syntax                                       " }}}1
    " omni completion                                                  {{{1
    autocmd FileType xml setlocal
                \ omnifunc=xmlcomplete#CompleteTags
                                                                     " }}}1
endfunction

augroup vrc_xml_files
    autocmd!
    " call support function                                            {{{1
    autocmd FileType xml call VrcXMLSupport()
                                                                     " }}}1
augroup END

" vim: set foldmethod=marker :
