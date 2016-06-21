" Vim configuration: startup

" NERDTree used if opened with no file                                 {{{1
" - function VrcNerdtreeOnStartup()                                    {{{2
"   intent: open NERDTree if no file opened
"   params: nil
"   return: nil
function! VrcNerdtreeOnStartup()
    " check that nerdtree is running
    if !exists(':NERDTree')
        return
    endif
    if argc() == 0 && !exists("s:std_in")
        NERDTree
    endif
endfunction                                                          " }}}2
augroup nerd_open
    autocmd!
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * call VrcNerdtreeOnStartup()
augroup END

" Change to document directory                                         {{{1
" - function VrcCdToLocalDir()                                         {{{2
"   intent: cd to local directory
"   params: nil
"   return: nil
function! VrcCdToLocalDir()
    if expand('%:p') !~ '://'
        lcd %:p:h
    endif
endfunction                                                          " }}}2
au BufEnter * call VrcCdToLocalDir()

" Remember cursor location                                             {{{1
" - function VrcCursorToLastPosition()                                 {{{2
"   intent: jump cursor to position on last exit
"   params: nil
"   return: nil
function! VrcCursorToLastPosition()
    " from ':h last-position-jump'
    if line("'\"") > 0 && line("'\"") <= line('$')
        exe "normal g`\""
    endif
endfunction                                                          " }}}2
augroup cursor_pos
    autocmd!
    autocmd BufReadPost * call VrcCursorToLastPosition()
augroup END

" Initialise neocomplete                                               {{{1
" - function VrcInitialiseNeocomplete()                                {{{2
"   intent: initialise neocomplete if it is running
"   params: nil
"   return: nil
function! VrcInitialiseNeocomplete()
    " ensure neocomplete is being used
    " var is set in 'dein#add' call for plugin
    if !exists('g:neocomplete#enable_at_startup')
        return
    endif
    if g:neocomplete#enable_at_startup != 1
        return
    endif
    " initialise
    call neocomplete#initialize()
endfunction                                                           "}}}2
augroup neo_init
    autocmd!
    autocmd VimEnter * call VrcInitialiseNeocomplete()
augroup END                                                          " }}}1

" vim: set foldmethod=marker :
