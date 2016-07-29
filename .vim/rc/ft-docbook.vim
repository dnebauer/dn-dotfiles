" Vim configuration: docbook file support

function! s:DocbookSupport()
    " fold by syntax                                                   {{{1
    setlocal foldmethod=syntax                                       " }}}1
    " syntax checking                                                  {{{1
    " - used by vim-dn-docbk ftplugin
    let g:dn_docbk_relaxng_schema =
                \ '/usr/share/xml/docbook/schema/rng/5.0/docbook.rng'
    let g:dn_docbk_schematron_schema =
                \ '/usr/share/xml/docbook/schema/schematron/'
                \ . '5.0/docbook.sch'
    if VrcOS() ==# 'unix'
        let g:dn_docbook_xml_catalog
                    \ = $HOME . '/.config/docbk/catalog.xml'
    endif                                                            " }}}1
endfunction

augroup vrc_docbook_files
    autocmd!
    autocmd FileType docbk call s:DocbookSupport()
augroup END

" vim: set foldmethod=marker :
