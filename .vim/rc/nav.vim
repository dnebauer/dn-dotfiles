" Vim configuration: navigation

" Unite.vim: navigate buffers, MRU, yank history                       {{{1
" - buffer list [N]  : ,b
nnoremap <silent> ,b :<C-u>Unite buffer<CR>
" - recent files [N] : ,r
nnoremap <silent> ,r :<C-u>Unite file_mru<CR>
" - file search [N]  : ,f
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap ,f :<C-u>Unite -start-insert file_rec/async:!<CR>
" - yank history [N] : ,y
let g:unite_source_history_yank_enable = 1
nnoremap ,y :<C-u>Unite history/yank<CR>

" Backspace                                                            {{{1
" - set behaviour
set backspace=indent,eol,start
" - additional page up key [N,V] : <Backspace>
nnoremap <BS> <PageUp>
vnoremap <BS> <PageUp>

" Space                                                                {{{1
" - additional page down key [N,V] : <Space>
nnoremap <Space> <PageDown>
vnoremap <Space> <PageDown>

" Arrows                                                               {{{1
" - default to arrows off
autocmd VimEnter,BufNewFile,BufReadPost * silent! call EasyMode()
" - toggle hardmode [N] : \hr
nnoremap <LocalLeader>hm <Esc>:call ToggleHardMode()<CR>

" Visual shift                                                         {{{1
" - repeat visual shift operation [V]: <,>
vnoremap < <gv
vnoremap > >gv

" Sneak plugin                                                         {{{1
" - see basic.vim for handling of colon in normal mode
" - emulate easymotion (but better)
let g:sneak#streak = 1
" - replace 'f' with 1-char Sneak
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F
" - replace 't' with 1-char sneak
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T
                                                                     " }}}1

" vim: set foldmethod=marker :
