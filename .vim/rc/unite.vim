" Vim configuration: unite plugin and helpers

" - configure: map prefix                                              {{{1
nnoremap [unite] <Nop>
nmap , [unite]
" - configure: settings                                                {{{1
augroup vrc_unite_settings
    autocmd!
    autocmd FileType unite call s:UniteSettings()
augroup END
function! s:UniteSettings()
    " exit with Esc
    nmap <buffer> <ESC>  <Plug>(unite_exit)
    " supertab integration
    let b:SuperTabDisabled = 1
    " suppress regular buffer features
    setlocal noswapfile
    setlocal undolevels=-1
endfunction
" - ,b : source = buffers                                              {{{1
nnoremap <silent> [unite]b :<C-u>Unite
            \ -buffer-name=buffers
            \ -quick-match
            \ buffer<CR>
" - ,B : source = bibtex references                                    {{{1
nnoremap <silent> [unite]B :call <SID>Unite_BibTeX()<CR>
function! s:Unite_BibTeX()
    " pybtex is a prerequisite
    if !executable('pybtex')
        echo "Cannot run without 'pybtex'"
        return
    endif
    " need at least one valid bibtex file
    if exists('g:unite_bibtex_bib_files')
        if type(g:unite_bibtex_bib_files) != type([])
            echo 'g:unite_bibtex_bib_files must be a List'
            return
        endif
        call filter(g:unite_bibtex_bib_files, 'filereadable(v:val)')
    else
        let g:unite_bibtex_bib_files = []
    endif
    if empty(g:unite_bibtex_bib_files)
        echo 'No valid bibtex files specified'
        let l:file = input('Enter a bibtex filepath: ', '', 'file')
        if len(l:file) == 0
            echo ' '
            echo 'No filepath entered'
            return
        endif
        let l:file = fnamemodify(l:file, ':p')
        if !filereadable(l:file)
            echo ' '
            echo "Invalid file '" . l:file . "'"
            return
        endif
        call add(g:unite_bibtex_bib_files, l:file)
    else
        if len(g:unite_bibtex_bib_files) == 1
            echo 'Using bibtex file: '
        else
            echo 'Using bibtex files: '
        endif
        for l:file in g:unite_bibtex_bib_files
            echo '  ' . l:file
        endfor
        echo 'Press any key to proceed...'
        call getchar(1)
    endif
    " run unite
    Unite -buffer-name=bibtex bibtex
endfunction
" - ,c : source = command history                                      {{{1
nnoremap [unite]c :<C-u>Unite
            \ -buffer-name=commands
            \ history/command<CR>
" - ,f : source = file search                                          {{{1
nnoremap <silent> [unite]f :<C-u>Unite
            \ -buffer-name=files
            \ file_rec/async:!<CR>
" - ,F : source = recent files                                         {{{1
nnoremap <silent> ,F :<C-u>Unite
            \ -buffer-name=recent
            \ file_mru<CR>
" - ,g : source = grep files                                           {{{1
" set grep command and options                                         {{{2
function! s:SetGrepOptions()
    " possible utilities to use:
    " - highway (hw)
    "   [https://github.com/tkengo/highway]
    " - silver searcher (ag)
    "   [https://github.com/ggreer/the_silver_searcher]
    " - platinum searcher (pt)
    "   [https://github.com/monochromegane/the_platinum_searcher]
    " - ack-grep (ack-grep)
    "   [http://beyondgrep.com/]
    let l:utils = {
                \ 'ack-grep': {
                \     'default': '-i --no-heading --no-color -k -H',
                \     'recurse': '',
                \     },
                \ 'ag': {
                \     'default': "-i --vimgrep --hidden --ignore '.hg' "
                \              . " --ignore '.svn' --ignore '.git' "
                \              . " --ignore '.bzr' --smart-case",
                \     'recurse': '',
                \     },
                \ 'hw': {
                \     'default': '--no-group --no-color',
                \     'recurse': '',
                \     },
                \ 'pt': {
                \     'default': '--nogroup --nocolor',
                \     'recurse': '',
                \     },
                \ }
    let l:preferences = ['ag', 'pt', 'ack-grep', 'hw']
    for l:util in l:preferences
        if !has_key(l:utils, l:util)
            echoerr "Invalid unite grep utility preference '"
                        \ . l:util . "'"
            continue
        endif
        if executable(l:util)
            let g:unite_source_grep_command = l:util
            let g:unite_source_grep_default_opts
                        \ = l:utils[l:util]['default']
            let g:unite_source_grep_recursive_opt
                        \ = l:utils[l:util]['recurse']
            break
        endif
    endfor
endfunction
call s:SetGrepOptions()                                              " }}}2
nnoremap <silent> ,g :<C-u>Unite
            \ -buffer-name=grep
            \ grep<CR>
" - ,h : source = help on word under cursor                            {{{1
nnoremap <silent> [unite]h :<C-u>UniteWithCursorWord
            \ -buffer-name=help
            \ help<CR>
" - ,H : source = help on entered word                                 {{{1
nnoremap <silent> [unite]H :<C-u>Unite
            \ -buffer-name=help
            \ help<CR>
" - ,m : source = mappings                                             {{{1
nnoremap <silent> [unite]m :<C-u>Unite
            \ -buffer-name=mappings
            \ mapping<CR>
" - ,o : source = outline                                              {{{1
nnoremap <silent> [unite]o :<C-u>Unite
            \ -buffer-name=outline
            \ outline<CR>
" - ,r : source = register                                             {{{1
nnoremap <silent> [unite]r :<C-u>Unite
            \ -buffer-name=registers
            \ -quick-match
            \ register<CR>
" - ,s : source = search history                                       {{{1
nnoremap <silent> [unite]s :<C-u>Unite
            \ -buffer-name=search
            \ history/search<CR>
" - ,t : source = tags                                                 {{{1
nnoremap <silent> [unite]t :<C-u>Unite
            \ -buffer-name=tags
            \ tag:%<CR>
" - ,u : source = [blank]                                              {{{1
nnoremap [unite]u :<C-u>Unite
" - ,U : source = unicode                                              {{{1
nnoremap <silent> [unite]U :<C-u>Unite
            \ -buffer-name=unicode
            \ unicode<CR>
" - ,y : source = yank history                                         {{{1
let g:unite_source_history_yank_enable = 1
nnoremap <silent> [unite]y :<C-u>Unite
            \ -buffer-name=yank
            \ history/yank<CR>
                                                                     " }}}1

" vim: set foldmethod=marker :
