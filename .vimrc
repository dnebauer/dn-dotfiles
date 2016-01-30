" Vim Configuration File:
" Credits:                                                        {{{1
" based in part on Amix's "Ultimate Vimrc"
"   - accessed at http://amix.dk/vim/vimrc.html
"   - version 3.6 - 25/08/10 14:40:30

" UTILITY FUNCTIONS:                                            " {{{1
" function VrcCmd(cmd)                                            {{{2
" intent: execute command line command
" params: 1 - command
" return: nil
function! VrcCmd(cmd)
    execute 'menu Foo.Bar :' . a:cmd
    emenu Foo.Bar
    unmenu Foo
endfunction                                                     " }}}2
" function VrcMsg(msg, [clear])                                   {{{2
" intent: display message in command line
" params: 1 - message
"         2 - clear message after brief display (boolean, optional)
" return: nil
function! VrcMsg(msg, ...)
	if mode() == 'i' | execute "normal \<Esc>" | endif
	echohl ModeMsg | echo a:msg | echohl Normal
    if a:0 > 0 && a:1 | sleep 1 | execute "normal :\<BS>" | endif
endfunction                                                     " }}}2
" function VrcHasFunction(function, plugin)                       {{{2
" intent: check whether function exists
" params: 1 - function name
"         2 - plugin providing function
" prints: error message if function not found
" return: boolean
function! VrcHasFunction(function, plugin)
    if strlen(a:function) == 0
        echoerr "'No function name supplied to 'VrcHasFunction'"
        return
    endif
    if strlen(a:plugin) == 0
        echoerr "'No plugin name supplied to 'VrcHasFunction'"
        return
    endif
    if !exists('*' . a:function)
        echoerr "Cannot find function '" . a:function . "'"
        echoerr "Plugin '" . a:plugin . "' does not appear to be loaded"
    endif
endfunction                                                     " }}}2
" function VrcAddThesaurus(thesaurus)                             {{{2
" intent: add thesaurus file
" params: 1 - thesaurus filepath
" prints: error message if thesaurus file not found
" return: nil
function! VrcAddThesaurus(thesaurus)
    " make sure thesaurus file exists
    if strlen(a:thesaurus) == 0
        return
    endif
    if filereadable(resolve(expand(a:thesaurus)))
        " add to thesaurus file variable (string, comma-delimited)
        if strlen(a:thesaurus) > 0
            let &thesaurus .= ','
        endif
        let &thesaurus .= a:thesaurus
    endif
endfunction                                                     " }}}2
" function VrcHasExecutables(executables)                         {{{2
" intent: ensure all executables are available
" params: 1 - list of executables
" prints: nil - fails silently if executables missing
" return: boolean
function! VrcHasExecutables(executables)
    let l:result = 1    " true
    for l:executable in a:executables
        if !executable(l:executable)
            let l:result = 0    " false
        endif
    endfor
    return l:result
endfunction                                                     " }}}2
" function VrcLocalRepoUpdatedRecently(dir, time)                 {{{2
" intent: check that a local repository has been updated
"         within a given time period
" params: dir  - directory containing local repository
"         time - time in seconds
" prints: error messages if setup fails
" return: boolean
" note:   determines time of last 'fetch' operation
"         (so also 'pull' operations)
" note:   uses python and python modules 'os' and 'time'
" note:   designed to determine whether repo needs to be
"         updated, so if it fails it returns false,
"         presumably triggering an update
" note:   a week is 604800 seconds
" note:   will display error message if:
"         - cannot find '.git/FETCH_HEAD' file in directory
"         - time value is invalid
" note:   will fail silently if:
"         - python is absent
function! VrcLocalRepoUpdatedRecently(dir, time)
    " need python
    if ! executable('python') | return | endif
    " check parameters
    let l:dir = resolve(expand(a:dir))
    if ! isdirectory(l:dir)
        echoerr "Not a valid directory ('" . l:dir . "')"
        return
    endif
    let l:fetch = l:dir . '/.git/FETCH_HEAD'
    if ! filereadable(l:fetch)
        echoerr "Not a valid git repository ('" . l:dir . "')"
        return
    endif
    if a:time !~ '^0$\|^[1-9][0-9]*$'
        echoerr "Not a valid time ('" . a:time . "')"
    endif
    " get time of last fetch (in seconds since epoch)
    let l:cmd = "python -c \"import os;print os.stat('"
                \ . l:fetch . "').st_mtime\""
    let l:last_fetch_list = systemlist(l:cmd)
    if v:shell_error | return | endif
    if type(l:last_fetch_list) != type([]) || len(l:last_fetch_list) != 1
                \ || len(l:last_fetch_list[0]) == 0
        " expected single-item list
        return
    endif
    let l:last_fetch = l:last_fetch_list[0]
    " get current time (in seconds since epoch)
    let l:cmd = "python -c \"import time;print int(time.time())\""
    let l:now_list = systemlist(l:cmd)
    if v:shell_error | return | endif
    if type(l:now_list) != type([]) || len(l:now_list) != 1
                \ || len(l:now_list[0]) == 0
        " expected single-item list
        return
    endif
    let l:now = l:now_list[0]
    " have both time values
    " - if less than the supplied time then return true
    let l:diff = l:now - l:last_fetch
    if l:diff < a:time | return 1 | else | return | endif
endfunction                                                     " }}}2
" function VrcLocalRepoFetch(dir)                                 {{{3
" intent: perform a fetch on a local git repository
" params: path to '.git' subdirectory in repository
" prints: error messages if fails
" return: boolean, whether fetch successful
function! VrcLocalRepoFetch(dir)
    " check directory
    let l:dir = resolve(expand(a:dir))
    if ! isdirectory(l:dir)
        echoerr "Invalid repository '.git' directory ('" . a:dir . "')"
        return
    endif
    " need git
    if ! executable('git')  " need git to update
        echoerr 'Cannot find git - unable to perform fetch operation'
        return
    endif
    " do fetch
    let l:cmd = "git --git-dir='" . l:dir . "' fetch"
    if exists('l:err') | unlet l:err | endif
    let l:err = systemlist(l:cmd)
    if v:shell_error
        echoerr "Unable to perform fetch operation on '" . a:dir . "'"
        if len(l:err) > 0
            echoerr 'Error message:'
            for l:line in l:err | echoerr '  ' . l:line | endfor
        endif
        return
    endif  " v:shell_error
    " success if still here
    return 1
endfunction                                                     " }}}3

" VARIABLES:                                                    " {{{1
" set os-dependent variables                                      {{{2
" - win32unix is cygwin/babun
if has('win32') || has ('win64') || has('win95')
    let $VIM_HOME = $HOME . '/vimfiles'
    let $VIM_RC = '_vimrc'
    let $VIM_OS = 'windows'
elseif has('unix') || has('win32unix')
    let $VIM_HOME = $HOME . '/.vim'
    let $VIM_RC = '.vimrc'
    let $VIM_OS = 'unix'
endif                                                           " }}}2

" HANDLE PLUGINS:                                               " {{{1
" configure neobundle                                             {{{2
" - filetype needs to be off before running                       }}}2
" adding and updating plugins                                     {{{2
" - internet connection is required
" - after adding a new bundle install it with:
"       NeoBundleInstall [within vim], or
"       vim +NeoBundleInstall +qall [command line]
" - to update all plugins:
"       NeoBundleInstall! [within vim], or
"       vim +NeoBundleInstall! +qall [command line]               }}}2
" setup neobundle                                               " {{{2
set nocompatible
filetype off
" may need make to build bundle
let g:make = 'gmake'
if system('uname -o') =~ '^GNU/\|^Cygwin'
    let g:make = 'make'
endif
" load neobundle
set runtimepath+=$VIM_HOME/bundle/neobundle.vim/
call neobundle#begin(expand("$VIM_HOME/bundle/"))
" load plugins                                                    {{{2
" neobundle manages itself                                        {{{3
NeoBundleFetch 'Shougo/neobundle.vim'
    " recommends vimproc.vim
    NeoBundle 'Shougo/vimproc.vim', {
                \ 'build' : {
                \     'windows' : 'tools\\update-dll-mingw',
                \     'cygwin'  : 'make -f make_cygwin.mak',
                \     'mac'     : 'make -f make_mac.mak',
                \     'linux'   : 'make',
                \     'unix'    : 'gmake',
                \     },
                \ }                                             " }}}3
" utilities (my own!)                                             {{{3
NeoBundle 'dnebauer/vim-dn-utils'                               " }}}3
" calendar (display calendar)                                     {{{3
NeoBundle 'mattn/calendar-vim'                                  " }}}3
" color schemes                                                 " {{{3
    " - solarized
    NeoBundle 'altercation/vim-colors-solarized'
    " - peaksea
    NeoBundle 'peaksea'
    " - hybrid
    NeoBundle 'w0ng/vim-hybrid'
    " - bad wolf
    NeoBundle 'sjl/badwolf'
    " - railscasts
    NeoBundle 'jpo/vim-railscasts-theme'
    " - zenburn
    NeoBundle 'jnurmine/Zenburn'
    " - lucius
    NeoBundle 'jonathanfilip/vim-lucius'
    " - atelier
    NeoBundle 'atelierbram/vim-colors_atelier-schemes'
    " - papercolor
    NeoBundle 'NLKNguyen/papercolor-theme'                      " }}}3
" completion and snippets                                       " {{{3
NeoBundle 'Shougo/neocomplete'                 " completion engine
    NeoBundle 'Shougo/neomru.vim'              " most recently used
    NeoBundle 'Shougo/context_filetype.vim'    " contextual filetype
    NeoBundle 'Shougo/neoinclude.vim'          " use include files
    NeoBundle 'Shougo/neco-syntax'             " use syntax files
    NeoBundle 'Shougo/neopairs.vim'            " insert () pairs
    NeoBundle 'c9s/perlomni.vim'               " perl completion
    NeoBundle 'Shougo/neco-vim'                " vimscript completion
NeoBundle 'Shougo/neosnippet'                  " snippets engine
    NeoBundle 'honza/vim-snippets'             " snippets collection
    " Bundle 'jhradilek/vim-docbk'                                {{{4
    " - docbook and relax ng snippets
    " - installed to custom directory and accessed using
    "   neosnippet variable g:neosnippet#snippets_directory
    " - see 'COMPLETION AND SNIPPETS' section below for details   }}}4
" delimitate (autocomplete parens, quotes, brackets, etc.)        {{{3
NeoBundle 'raimondi/delimitmate'                                " }}}3
" docbook                                                         {{{3
NeoBundle 'jhradilek/vim-docbk'
NeoBundle 'dnebauer/vim-dn-docbk'                               " }}}3
" domains (find meaning of internet domain)                       {{{3
NeoBundle 'whatdomain.vim'                                      " }}}3
" hardmode (disable character-wise navigation)                    {{{3
NeoBundle 'wikitopian/hardmode'                                 " }}}3
" headlights (add bundles menu)                                   {{{3
NeoBundle 'mbadran/headlights'                                  " }}}3
" html5                                                           {{{3
NeoBundle 'othree/html5.vim'
" info (gnu info documentation viewer)                            {{{3
NeoBundle 'info.vim'                                            " }}}3
" latex                                                           {{{3
NeoBundle 'coot/atp_vim'    " Automatic LaTeX Plugin for Vim
NeoBundle 'dnebauer/vim-dn-latex'                               " }}}3
" markdown support                                                {{{3
NeoBundle 'dnebauer/vim-dn-markdown'                            " }}}3
" navigation (files, buffers, MRU, etc)                           {{{3
NeoBundle 'Shougo/unite.vim'
" perl (main ftplugin, help, auxiliary plugin)                    {{{3
NeoBundle 'vim-perl/vim-perl'
if executable('perldoc')
    NeoBundle 'perlhelp.vim'
endif
NeoBundle 'dnebauer/vim-dn-perl'                                " }}}3
" sparkup (write faster html)                                     {{{3
NeoBundle 'rstacruz/sparkup'                                    " }}}3
" status line modification                                        {{{3
NeoBundle 'bling/vim-airline'                                   " }}}3
" syntax checker                                                  {{{3
NeoBundle 'scrooloose/syntastic'                                " }}}3
" tagbar (class outline viewer)                                   {{{3
NeoBundle 'majutsushi/tagbar'
    " requires easytags
    NeoBundle 'xolox/vim-easytags'
        " requires misc
        NeoBundle 'xolox/vim-misc'
    " javascript support
        " not available in cygwin as nodejs no longer supported in cygwin
        " install jcstags using command:
        "   su -c "npm install -g git://github.com/ramitos/jsctags.git"
        " configured later under TagList configuration
        " jcstags requires tern_for_vim
    if system('uname -o') !~ '^Cygwin'
        NeoBundle 'marijnh/tern_for_vim'
    endif
        " requires node.js (deb 'nodejs') and npm (deb 'npm')
        " must install tern server in bundle directory with command:
        "   npm install
    " markdown support
    NeoBundle 'jszakmeister/markdown2ctags'
        " configured later under TagList configuration
    " php support
        " not available in cygwin as build fails
    if system('uname -o') !~ '^Cygwin'
        NeoBundle 'vim-php/tagbar-phpctags.vim'
    endif
        " must build 'phpctags' executable in bundle dir with command:
        "   make
        " configured later under TagBar configuration             }}}3
" thesaurus (online, mapped to <Leader>K)                         {{{3
NeoBundle 'beloglazov/vim-online-thesaurus'                     " }}}3
" tmux                                                            {{{3
NeoBundle 'tmux-plugins/vim-tmux'    " tmux.conf ftplugin
NeoBundle 'christoomey/vim-tmux-navigator'                      " }}}3
" vcscommand (CVS, SVN, SVK, git, bzr, and hg integration)        {{{3
NeoBundle 'vcscommand.vim'                                      " }}}3
" xml                                                             {{{3
NeoBundle 'xml.vim'
" xquery                                                          {{{3
NeoBundle 'XQuery-indentomnicompleteftplugin'
" close down neobundle                                            {{{2
call neobundle#end()
" check for uninstalled bundles
filetype plugin indent on
NeoBundleCheck                                                  " }}}2

" MAJOR FEATURES:                                               " {{{1
" plugins, indenting, syntax                                      {{{2
filetype plugin on
filetype indent on
syntax enable                                                   " }}}2
" dispense with outdated vi compatibility                         {{{2
" - nocompatible was set at beginning of plugin handling          }}}2
" use utf-8 encoding                                              {{{2
set encoding=utf-8
" try Australian, UK, US and generic English language settings in turn
" E197 error means could not set language
try | lang en_AU | catch /^Vim\((\a\+)\)\=:E197:/
    try | lang en_GB | catch /^Vim\((\a\+)\)\=:E197:/
        try | lang en_US | catch /^Vim\((\a\+)\)\=:E197:/
            try | lang en | catch /^Vim\((\a\+)\)\=:E197:/
            endtry  " lang en
        endtry  " en_US
    endtry  " en_GB
endtry  " en_AU                                                   }}}2

" SCREEN LAYOUT AND APPEARANCE:                                 " {{{1
" basic settings                                                  {{{2
" minimum number of lines visible above/below cursor
set scrolloff=3
" show mode in last line
set showmode
" screen flashes instead of beeping
set visualbell
" duration in msec of visual bell
set t_vb="<Esc>|1000f"
" highlight line cursor is on
set cursorline
" assume terminal is fast
set ttyfast
" no redraw executing macros, etc.
set lazyredraw
" show the cursor position all the time
set ruler
" turns on wrapping
set wrap
" keys moving cursor beyond line end
set whichwrap+=<,>
" long lines not broken by hard EOL
set formatoptions+=l
" autoinsert comment headers
set formatoptions+=ro
" enable word wrap
set linebreak
" don't wrap words by default
set textwidth=0
" status line always displayed
set laststatus=2
" show line numbers relative to cursor line
set relativenumber
" toggle line numbering: <F7> [N]
nnoremap <silent> <F7> :set nu!<CR>
" when tab-completing command show matches above cmd line...
set wildmenu
" ...and list all matches; complete till longest string
set wildmode=list:longest
" show (partial) command in status line
set showcmd
" show matching brackets
set showmatch                                                   " }}}2
" guioptions                                                    " {{{2
" - a,A = visual selection globally available for pasting,
" - g = inactive menu items display but greyed out,
" - i = use vim icon,
" - m = show menu bar,
" - L = left scrollbar if vertical split,
" - t = include tearoff menu items,
" - T = include toolbar
" suppress R scrollbar to prevent 'resize on startup'
" bug (occurred ~ ver 1:6.3-013+2)
set guioptions=aAgimLtT                                         " }}}2
" console menu when no gui (mapped to <F4>)                     " {{{2
if !has('gui_running')
    source $VIMRUNTIME/menu.vim
    set wildmenu
    set cpo-=<
    set wcm=<C-Z>
    map <F4> :emenu <C-Z>
endif                                                           " }}}2
" fonts                                                         " {{{2
" useful utilities for determining fonts: xfontsel, xlsfonts
" guifont: any spaces after commas must be escaped
"          cannot use quotes around font name
if has('gui_running')
    if $VIM_OS == 'unix'
        set guifont=Andale\ Mono\ 18,
                    \\ FreeMono\ 16,
                    \\ Courier\ 18,
                    \\ Bitstream\ Vera\ Sans\ Mono\ 16,
                    \\ Monospace\ 18
    endif
    if $VIM_OS == 'windows'
        set guifont=Bitstream\ Vera\ Sans\ Mono:h10
    endif
else  " no gui
    set guifont=-unknown-freesans-medium-r-normal--0-0-0-0-p-0-iso10646-1
endif                                                           " }}}2
" TagBar plugin for tags                                        " {{{2
" toggle tag bar: <F8> [N]
nmap <F8> :TagbarToggle<CR>
" manually regenerate tags file: \ct [N,I]
inoremap <Leader>ct <Esc>:!UpdateTags<CR>a
" ctags command needs redraw due to interaction with xterm
nnoremap <Leader>ct :silent! UpdateTags<CR>:redraw!<CR>
" support for additional languages
" - unless otherwise noted these are taken from
"   https://github.com/majutsushi/tagbar/wiki
" haskell support                                               " {{{3
if executable('hasktags')
    let g:tagbar_type_haskell = {
        \ 'ctagsbin'  : 'hasktags',
        \ 'ctagsargs' : '-x -c -o-',
        \ 'kinds'     : [
            \  'm:modules:0:1',
            \  'd:data: 0:1',
            \  'd_gadt: data gadt:0:1',
            \  't:type names:0:1',
            \  'nt:new types:0:1',
            \  'c:classes:0:1',
            \  'cons:constructors:1:1',
            \  'c_gadt:constructor gadt:1:1',
            \  'c_a:constructor accessors:1:1',
            \  'ft:function types:1:1',
            \  'fi:function implementations:0:1',
            \  'o:others:0:1'
        \ ],
        \ 'sro'        : '.',
        \ 'kind2scope' : {
            \ 'm' : 'module',
            \ 'c' : 'class',
            \ 'd' : 'data',
            \ 't' : 'type'
        \ },
        \ 'scope2kind' : {
            \ 'module' : 'm',
            \ 'class'  : 'c',
            \ 'data'   : 'd',
            \ 'type'   : 't'
        \ }
    \ }
endif                                                           " }}}3
" javascript support                                            " {{{3
" - installed jcstags as node.js app (see plugin commands above)
" makefile support
" - also edited ~/.ctags file
let g:tagbar_type_make = {
    \ 'kinds':[
    \ 'm:macros',
    \ 't:targets'
    \ ]
\ }                                                             " }}}3
" markdown support                                              " {{{3
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '/home/david/.vim/bundle/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }                                                             " }}}3
" perl support                                                    {{{3
" - based on ctags settings in ctags config file
" - ctags config file provided by debian package 'dn-ctags-conf'
let g:tagbar_type_perl = {
    \ 'ctagstype': 'perl',
    \ 'kinds' : [
        \ 'a:attribute',
        \ 't:subtype',
        \ 's:subroutines',
        \ 'c:constants',
        \ 'e:extends',
        \ 'u:use',
        \ 'r:role',
    \ ],
    \ 'sro' : '::',
    \ 'kind2scope' : {},
\ }                                                             " }}}3
" php support                                                   " {{{3
" - from https://github.com/vim-php/tagbar-phpctags.vim
if filereadable('/home/david/.vim/bundle/tagbar-phpctags.vim/bin/phpctags')
    let g:tagbar_phpctags_bin = 
                \ '/home/david/.vim/bundle/tagbar-phpctags.vim/bin/phpctags'
endif
" colour scheme                                                 " {{{2
" function VrcSetColorScheme()                                  " {{{3
" intent: set colour scheme
" params: 1 - colour scheme key
" return: nil
" note:   sets colour schemes for gvim ('gui_running') and vim
function! VrcSetColorScheme(gui, term)
    if has('gui_running')    " gui
        if     a:gui == 'solarized'
            set background=dark
            colorscheme solarized
        elseif a:gui == 'peaksea'
            set background=dark
            colorscheme peaksea
        elseif a:gui == 'desert'
            colorscheme desert
        elseif a:gui == 'hybrid'
            let g:hybrid_use_Xresources = 1
            colorscheme hybrid
        elseif a:gui == 'badwolf'
            let g:badwolf_darkgutter = 1
            colorscheme badwolf
        elseif a:gui == 'railscasts'
            colorscheme railscasts
        elseif a:gui == 'zenburn'
            colorscheme zenburn
        elseif a:gui == 'lucius'
            colorscheme lucius
            "LuciusDark|LuciusDarkHighContrast|LuciusDarkLowContrast
            "LuciusBlack|LuciusBlackHighContrast|LuciusBlackLowContrast
            "LuciusLight|LuciusLightLowContrast
            "LuciusWhite|LuciusWhiteLowContrast
            LuciusDarkLowContrast
        elseif a:gui == 'atelierheath'
            colorscheme base16-atelierheath
        elseif a:gui == 'atelierforest'
            colorscheme base16-atelierforest
        elseif a:gui == 'papercolor'
            set background=dark
            set t_Co=256
            colorscheme PaperColor
        else
            let l:msg = "Invalid gui colorscheme code '" . a:gui . "'"
            echoerr l:msg
        endif
    else    " no gui, presumably terminal/console
        set t_Co=256    " improves all themes in terminals
        if     a:term == 'solarized'
            colorscheme solarized
        elseif a:term == 'peaksea'
            colorscheme peaksea
        elseif a:term == 'desert'
            colorscheme desert
        elseif a:term == 'badwolf'
            let g:badwolf_darkgutter = 1
            colorscheme badwolf
        elseif a:term == 'hybrid'
            let g:hybrid_use_Xresources = 1
            colorscheme hybrid
            let g:colors_name = 'hybrid'
        elseif a:term == 'railscasts'
            colorscheme railscasts
        elseif a:term == 'zenburn'
            colorscheme zenburn
        elseif a:term == 'lucius'
            colorscheme lucius
            "LuciusDark|LuciusDarkHighContrast|LuciusDarkLowContrast
            "LuciusBlack|LuciusBlackHighContrast|LuciusBlackLowContrast
            "LuciusLight|LuciusLightLowContrast
            "LuciusWhite|LuciusWhiteLowContrast
            LuciusLightLowContrast
        elseif a:term == 'papercolor'
            set background=dark
            colorscheme PaperColor
        else
            let l:msg = "Invalid terminal colorscheme code '" . a:term . "'"
            echoerr l:msg
        endif
    endif
endfunction                                                     " }}}3
" - params:
"   1 - gui/gvim = solarized|peaksea|desert|hybrid|badwolf|railscasts|
"                  zenburn|lucius|atelierheath|atelierforest|papercolor
"   2 - term/vim = solarized|peaksea|desert|badwolf|hybrid|railscasts|
"                  zenburn|lucius|papercolor
call VrcSetColorScheme('peaksea', 'desert')                     " }}}2
" status line (vim-airline)                                     " {{{2
" - display all buffers when only one is open
let g:airline#extensions#tabline#enabled = 1
" - toggle light and dark themes
call togglebg#map('<F5>')                                       " }}}2
" folding                                                         {{{2
" xml/docbook
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax
let g:docbk_syntax_folding=1
au FileType docbk setlocal foldmethod=syntax                    " }}}2

" TABS AND INDENTING:                                           " {{{1
" set tab = 4 spaces
set tabstop=4
" set tab = 4 spaces
set softtabstop=4
" force spaces for tabs
set expandtab
" copy indent from current line to new
set autoindent
" attempt intelligent indenting
set smartindent
" number of spaces to use for autoindent
set shiftwidth=4

" COMPLETION AND SNIPPETS:                                      " {{{1
" neocomplete setup                                               {{{2
" disable AutoComplPop to prevent interference                    {{{3
let g:acp_enableAtStartup = 0
" enable automatically                                            {{{3
let g:neocomplete#enable_at_startup = 1
" use smartcase                                                   {{{3
let g:neocomplete#enable_smart_case = 1
" set minimum syntax keyword length                               {{{3
let g:neocomplete#sources#syntax#min_keyword_length = 3
" buffers in which to deactivate completion                       {{{3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" define dictionaries                                             {{{3
let g:neocomplete#sources#dictionary#dictionaries = {
            \   'default' : '',
            \   'vimshell' : $HOME.'/.vimshell_hist',
            \ }
" define non-default keyword patterns                             {{{3
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
" recommended key mappings                                        {{{3
" <CR>: close popup and save indent                               {{{4
inoremap <silent> <CR> <C-r>=<SID>VrcCrFunction()<CR>
function! s:VrcCrFunction()
    "return neocomplete#close_popup() . "\<CR>"
    "return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
    return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <C-l>: complete common mapping                                  {{{4
inoremap <expr><C-l> neocomplete#complete_common_string()
" <Tab>: completion                                               {{{4
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" <C-h>, <BS>: close popup and delete backword char               {{{4
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" <C-g>: undo completion                                          {{{4
inoremap <expr><C-g> neocomplete#undo_completion()
" superseded mappings                                             {{{4
"inoremap <expr><C-y>  neocomplete#close_popup()
"inoremap <expr><C-e>  neocomplete#cancel_popup()                 }}}4
" enable omni completion for some file types                      {{{3
autocmd FileType css setlocal
            \ omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal
            \ omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal
            \ omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal
            \ omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal
            \ omnifunc=xmlcomplete#CompleteTags
" recording keyword patterns used in omni completion              {{{3
" - hard to understand from help files
" - using examples from help page 'neocomplete.txt'
" ensure required variables exist                                 {{{4
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif
if !exists('g:neocomplete#sources#omni#functions')
    let g:neocomplete#sources#omni#functions = {}
endif
" perl (plugin: perlomni.vim)                                     {{{4
"let g:neocomplete#sources#omni#input_patterns.perl =
"            \ '\h\w*->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.perl =
            \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
" xquery (plugin: XQuery-indentomnicomplete)                      {{{4
let g:neocomplete#sources#omni#input_patterns.xquery =
            \ '\k\|:\|\-\|&'
let g:neocomplete#sources#omni#functions.xquery =
            \ 'xquerycomplete#CompleteXQuery'
                                                                " }}}4
" neosnippet setup                                                {{{2
" do not use default snippets                                     {{{3
let g:neosnippet#disable_runtime_snippets = { '_' : 1 }         " }}}3
" recommended key mappings                                        {{{3
" <C-k>: expand or jump to next placeholder                       {{{4
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
" <Tab>: intelligent behaviour (like SuperTab)                    {{{4
" superseded                                                      {{{5
"imap <expr><Tab> neosnippet#expandable_or_jumpable() ?
"            \ "\<Plug>(neosnippet_expand_or_jump)"
"            \ : pumvisible() ? "\<C-n>" : "\<Tab>"
"smap <expr><Tab> neosnippet#expandable_or_jumpable() ?
"            \ "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"    }}}5
smap <expr><Tab> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
" snippets marker concealment                                     {{{3
if has('conceal')
    set conceallevel=2 concealcursor=niv
endif                                                           " }}}3
" snippets directories                                            {{{3
" reset directories variable                                      {{{4
if exists('g:neosnippet#snippets_directory')
    unlet g:neosnippet#snippets_directory
endif
let g:neosnippet#snippets_directory = []
" add honza/vim-snippets (all languages)                          {{{4
call add(g:neosnippet#snippets_directory, 
            \ $VIM_HOME . '/bundle/vim-snippets/snippets')
" add jhradilek/vim-snippets (docbook, relax ng)                  {{{4
" - install to custom directory (~/.vim/repos/jhradilek/vim-snippets)
function! VrcAddDocbkSnippetsDir()                              " {{{5
    " ensure up to date snippet files from jhradilek/vim-docbk
    " are available in ~/.vim/repos/jhradilek/vim-snippets
    " check for repo directory
    let l:root = $VIM_HOME . '/repos/jhradilek'
    let l:dir = l:root . '/vim-snippets'
    let l:git = l:dir . '/.git'
    let l:snippets = l:dir . '/snippets'
    " try to add repo if not found
    let l:repo = 'https://github.com/jhradilek/vim-snippets.git'
    if ! isdirectory(l:git)
        if ! executable('git')
            echoerr 'Cannot find docbook snippets'
            echoerr 'Cannot find git - unable to install them'
            return
        endif
        echo 'Installing docbook and rng snippets...'
        let l:cmd = 'git clone ' . l:repo . ' ' . l:dir
        let l:err = systemlist(l:cmd)
        if v:shell_error
            echoerr 'Cannot find docbook snippets'
            echoerr 'Unable to install docbook snippets'
            if len(l:err) > 0
                echoerr 'Error message:'
                for l:line in l:err | echoerr '  ' . l:line | endfor
            endif
            return
        endif  " v:shell_error
        " perform initial fetch operation to ensure existence
        " of '.git/FETCH_HEAD'
        if VrcLocalRepoFetch(l:git) | echo 'Done' | endif
    endif  " ! isdirectory(l:git)
    " add snippets directory
    if isdirectory(l:snippets)
        call add(g:neosnippet#snippets_directory, l:snippets)
    else
        echoerr 'Unable to find docbook snippets directory'
    endif
    " exit if can't find local repo
    "  - must have been error message generated above
    if ! isdirectory(l:git) | return | endif
    " decide whether need to update
    if VrcLocalRepoUpdatedRecently(l:dir, 604800)  " try to update
        if ! executable('git')  " need git to update
            echoerr 'Cannot find git - unable to ensure'
            echoerr 'docbook snippets are up to date'
            return
        endif
        if ! VrcLocalRepoFetch(l:git) | return | endif
    endif  " l:do_fetch
    " presume success if haven't exited yet
    return 1
endfunction                                                     " }}}5
call VrcAddDocbkSnippetsDir()                                   " }}}4

" NAVIGATION AND EDITING KEYS:                                  " {{{1
" navigate buffers, MRU, yank history (unite plugin)              {{{2
" \<Space>b [N]: list buffers                                     {{{3
nnoremap <silent> <Leader><Space>b :<C-u>Unite buffer<CR>
" \<Space>r [N]: list most recently used files                    {{{3
nnoremap <silent> <Leader><Space>r :<C-u>Unite file_mru<CR>
" \<Space>f [N]: recursive fuzzy file search                      {{{3
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <Leader><Space>f :<C-u>Unite -start-insert file_rec/async:!<CR>
" \<Space>y [N]: list yank history                                {{{3
let g:unite_source_history_yank_enable = 1
nnoremap <Leader><Space>y :<C-u>Unite history/yank<CR>
                                                                " }}}3
" backspace behaviour in insert mode                              {{{2
set backspace=indent,eol,start
" move a line of text up or down: <M-j>,<M-k> [N,V]               {{{2
nnoremap <M-j> mz:m+<cr>`z
vnoremap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
nnoremap <M-k> mz:m-2<cr>`z
vnoremap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z
" disable arrow keys                                              {{{2
nnoremap <LocalLeader>hm <Esc>:call ToggleHardMode()<CR>
" move between buffers: <S-Left>,<S-Right> [N]                    {{{2
" - disabled now arrow keys are disabled
"nnoremap <S-Left> :bprevious<CR>
"nnoremap <S-Right> :bnext<CR>
" repeat visual shift operation: <,> [V]                          {{{2
vnoremap < <gv
vnoremap > >gv
" additional page up key: <Backspace> [N,V]                       {{{2
nnoremap <BS> <PageUp>
vnoremap <BS> <PageUp>
" additional page down key: <Space> [N,V]                         {{{2
nnoremap <Space> <PageDown>
vnoremap <Space> <PageDown>
                                                                " }}}2

" SYNTAX CHECKING:                                              " {{{1
" use status line                                                 {{{2
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*                                              " }}}2
" always fill location list with found errors                     {{{2
let g:syntastic_always_populate_loc_list = 1                    " }}}2
" always display error window when errors are detected            {{{2
let g:syntastic_auto_loc_list = 1                               " }}}2
" check for errors on opening, closing and quitting               {{{2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0                                 " }}}2
" docbook settings                                                {{{2
let g:dn_docbk_relaxng_schema =
            \ '/usr/share/xml/docbook/schema/rng/5.0/docbook.rng'
let g:dn_docbk_schematron_schema =
            \ '/usr/share/xml/docbook/schema/schematron/'
            \ . '5.0/docbook.sch'
if $VIM_OS == 'unix'
    let g:dn_docbook_xml_catalog 
                \ = $HOME . '/.config/docbk/catalog.xml'
endif

" SEARCHING:                                                    " {{{1
" initially last search match ('l') is not highlighted ('n')
set highlight=ln
" do case insensitive matching (if all lowercase)...
set ignorecase
" ...because force case sensitive matching if capital letters
set smartcase
" default to change all matches; 'g' now toggles to first only
set gdefault
" incremental search; display progressive match
set incsearch
" highlight search terms
set hlsearch
" force normal regex during search: /,? [N]
nnoremap / /\v
nnoremap ? ?\v
" search for selected text: /,? [V]
vnoremap / y/\v<C-R>"<CR>
vnoremap ? y?\v<C-R>"<CR>
" function VrcVisual(direction)                                   {{{2
" visual selection is used for various searches
" params: 1 - direction/type ['f'|'b'|'gv'|replace']
" return: nil
function! VrcVisual(direction) range
    " store away contents of unnamed register and save selection to it
    let l:saved_reg = @"
    execute "normal! vgvy"
    " tidy up selection by escaping control characters and removing newlines
    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", '', '')
    " extend selection forwards to next match on current selection
    if     a:direction == 'f'
        execute "normal /" . l:pattern . "<CR>"
    " extend selection backwards to next match on current selection
    elseif a:direction == 'b'
        execute "normal 2?" . l:pattern . "<CR>"
    " search current directory recursively for selection
    elseif a:direction == 'gv'
        call VrcCmd("vimgrep " . '/' . l:pattern . '/' . ' **/*')
    " make selection target for substitution
    elseif a:direction == 'replace'
        call VrcCmd('%s' . '/'. l:pattern . '/')
    endif
    " save selection to last search pattern register
    let @/ = l:pattern
    " restore unnamed register contents
    let @" = l:saved_reg
endfunction                                                     " }}}2
" extend selection to next match for initial selection: *,# [V]
" note that '#' does not currently work
vnoremap <silent> * :call VrcVisual('f')<CR>
vnoremap <silent> # :call VrcVisual('b')<CR>
" search current directory recursively for selected text (vimgrep): gv [V]
vnoremap <silent> gv :call VrcVisual('gv')<CR>
" make selected text target of a substitution command: \r [V]
vnoremap <silent> <Leader>r :call VrcVisual('replace')<CR>
" turn off match highlighing: <Space><Space> [N]
nnoremap <silent> <Leader><Space><Space> :nohlsearch<CR>

" SPELLING AND THESAURUS:                                         {{{1
" using combined AU/GB spell file in $VIM_HOME/spell/
set spell spelllang=en_au
" disable spell check at startup
set spell!
" function VrcSpellStatus()                                       {{{2
" intent: display spell check status
" params: nil
" return: nil
function! VrcSpellStatus()
    let l:msg = 'spell checking is '
    if &spell
        let l:msg .= 'ON (lang=' . &spelllang . ')'
    else
        let l:msg .= 'OFF'
    endif
    call VrcMsg(l:msg, 1)
endfunction                                                     " }}}2
" function VrcSpellToggle()                                     " {{{2
" intent: toggle spell checking
" params: nil
" return: nil
function! VrcSpellToggle()
    call VrcCmd('setlocal spell!<CR>')
    call VrcCmd('redraw<CR>')
    call VrcSpellStatus()
endfunction                                                     " }}}2
" toggle spelling: \st [N,I]
nnoremap <Leader>st :call VrcSpellToggle()<CR>
inoremap <Leader>st <Esc>:call VrcSpellToggle()<CR>
" report spell check status: \ss [N,V]
nnoremap <Leader>ss :call VrcSpellStatus()<CR>
inoremap <Leader>ss <Esc>:call VrcSpellStatus()<CR>
" jump to next/previous misspelled word: \sn,\sp [N]
nnoremap <Leader>sn ]s
nnoremap <Leader>sp [s
" add word to dictionary (spell list): \sa [N]
nnoremap <Leader>sa zg
" suggest correct spellings: \z? [N]
nnoremap <Leader>s? z=
" jump to misspelled word and make suggestions: ]= , [= [N,V]
noremap ]= ]sz=
noremap [= [sz=
" add thesaurus
call VrcAddThesaurus($VIM_HOME . '/thes/moby.thes')

" SAVING AND BUFFER BEHAVIOUR:                                    {{{1
" auto re-read of file if changed outside vim
set autoread
" don't keep a backup file
set nobackup
" remember marks for 20 previous files
" keep 50 lines of registers
set viminfo='20,<50
" keep 50 lines of command line history
set history=50
" undo history persists in a file
set undofile
" avoid clutter of backup|swap|undo files in local dir
if $VIM_OS == 'unix'
    set directory=./backup,~/var/vim/swap,.,/tmp
    set backupdir=./backup,~/var/vim/backup,.,/tmp
    set undodir=./backup,~/var/vim/undo,.,/tmp
endif
if $VIM_OS == 'windows'
    set directory=C:/Windows/Temp
    set backupdir=C:/Windows/Temp
    set undodir=C:/Windows/Temp
endif
" auto save before commands like :next and :make
set autowrite
" close current/all buffers: \bd,\ba [N]
nnoremap <Leader>bd :bdelete!<CR>
nnoremap <Leader>ba :1,300 bd!<CR>
" save ('update') file: <C-s> [N,V,I]
nnoremap <C-s> :update<CR>
vnoremap <C-s> <Esc>:update<CR>gv
inoremap <C-s> <Esc>:update<CR>:execute "normal l"<CR>:startinsert<CR>
" save and exit: ZZ [V,I]
inoremap ZZ <Esc>ZZ
vnoremap ZZ <Esc>ZZ
" quit without saving: ZQ [V,I]
inoremap ZQ <Esc>ZQ
vnoremap ZQ <Esc>ZQ
" update and switch windows: <C-w><C-w> [N,I]
inoremap <C-w><C-w> <Esc>:update<CR><C-w><C-w>
nnoremap <C-w><C-w> :update<CR><C-w><C-w>
" actions taken for all files in response to vim events           {{{2
augroup all_files
"   delete all existing autocmds for augroup
    au!
"   VimEnter:
"   if opened with no file then open file (NERD)tree              {{{3
    if exists(':NERDTree')
        au VimEnter *
                    \ if !argc() | 
                    \     NERDTree | 
                    \ endif
    endif                                                       " }}}3
"   configure and initialise neocomplete plugin                   {{{3
    au VimEnter * call neocomplete#initialize()
                                                                " }}}3
"   BufEnter:
"   exit if only window left open is a NERDTree                   {{{3
    if exists(':NERDTree')
        au BufEnter *
                    \ if ( 
                    \         winnr('$') == 1 && 
                    \         exists('b:NERDTreeType') &&
                    \         b:NERDTreeType == 'primary' 
                    \    ) |
                    \     quit |
                    \ endif
    endif                                                       " }}}3
"   cd to document directory                                      {{{3
    au BufEnter *
                \ if expand('%:p') !~ '://' |
                \     lcd %:p:h |
                \ endif                                         " }}}3
"   BufReadPost:
"   open with cursor at position of last file exit                {{{3
"   - see ':h last-position-jumo' for details
    au BufReadPost * 
                \ if line("'\"") > 0 && line("'\"") <= line('$') | 
                \     exe "normal g`\"" | 
                \ endif                                         " }}}3
"   FocusLost:
"   save on losing focus                                          {{{3
"   E141 = no file name for buffer
    au FocusLost *
                \ try |
                \     :wa |
                \ catch /^Vim\((\a\+)\)\=:E141:/ |
                \ endtry                                        " }}}3
augroup END                                                     " }}}2

" PRINTING:                                                       {{{1
" windows                                                         {{{2
"   use default print system                                      }}}2
" unix                                                            {{{2
" function VrcUseVimPostScript(fname)                             {{{3
" intent: print vim's postscript output
" params: 1 - filepath to vim's postscript output
" prints: feedback
" return: nil
" depend: assumes kprinter4 is available
" note:   vim handles return values from printing as per v:shell_error
"         that is, boolean values are reversed (1=failure, 0=success)
function! VrcUseVimPostScript(fname)
    let l:print_cmd = 'kprinter4' . ' ' . shellescape(a:fname)
    let l:feedback = systemlist(l:print_cmd)
    if v:shell_error
        echoerr 'Problem with printing'
        echoerr 'Command executed was:'
        echoerr '  ' . l:print_cmd
        if len(l:feedback)
            echoerr 'Shell feedback:'
            for l:line in l:feedback
                echo '  ' . l:line
            endfor
        endif
    endif
    call delete(a:fname)
    return v:shell_error
endfunction                                                     " }}}3
" function VrcEnscriptLanguages()                                 {{{3
" intent: get list of supported enscript highlight languages
" params: nil
" prints: nil
" return: nil
" depend: assumes enscript is available
function! VrcEnscriptLanguages()
    let l:output = systemlist('enscript --help-highlight')
    let l:langs = []
    for l:line in l:output
        if l:line =~ '^Name: [A-Za-z]\+$'
            let l:lang = tolower(strpart(l:line, 6))
            call add(l:langs, l:lang)
        endif
    endfor
    return l:langs
endfunction                                                     " }}}3
" function VrcEnscriptPostScript(fname)                           {{{3
" intent: create postscript from enscript and print it
" params: 1 - filepath to vim's default postscript output
" prints: feedback
" return: nil
" depend: assumes kprinter4, iconv and enscript are available
" note:   vim handles return values from printing as per v:shell_error
"         that is, boolean values are reversed (1=failure, 0=success)
function! VrcEnscriptPostScript(fname)
    " in this function return boolean values are reversed
    " - vim clearly expects return values as per v:shell_error logic
    " ignoring vim's postscript output and creating our own
    call delete(a:fname)
    " get filepath of postscript output file
    let l:ps_output = tempname() . '.ps'
    let l:source = expand('%')
    " generate postscript
    " - iconv converts encoding to latin1
    " - enscript generate postscript
    "   . bug means enscript does not honour its '--footer' argument
    "   . can fix with custom header file
    "   . use custom header file '~/.enscript/simple2.hdr' if present
    "   . additional bug means '$=' escape for total page count does not work
    "   . so use 'Page X' rather than 'Page X of Y' in footer
    let l:postscript_cmd = ''
                \ . ' ' . 'iconv'
                \ . ' ' . '-c '
                \ . ' ' . '--from-code=' . &encoding
                \ . ' ' . '--to-code=iso-8859-1'
                \ . ' ' . shellescape(l:source)
                \ . ' ' . '|'
                \ . ' ' . 'enscript'
    let l:langs = VrcEnscriptLanguages()
    if count(l:langs, &filetype)
        let l:postscript_cmd .= ''
                \ . ' ' . '--color=1'
                \ . ' ' . '--highlight=' . &filetype
    endif
    let l:postscript_cmd .= ''
                \ . ' ' . '--word-wrap'
                \ . ' ' . '--mark-wrapped-lines=arrow'
    if filereadable(resolve($HOME . '/.enscript/simple2.hdr'))
        let l:postscript_cmd .= ' ' . '--fancy-header=simple2'
    endif
    let l:postscript_cmd .= ''
                \ . ' ' . "--header='|" . l:source . "|%D{%Y-%m-%d %H:%M}'"
                \ . ' ' . "--footer='|Page $%|'"
                \ . ' ' . '--output=' . shellescape(l:ps_output)
    let l:feedback = systemlist(l:postscript_cmd)
    if v:shell_error
        echo 'Problem generating postscript'
        echo 'Command executed was:'
        echo '  ' . l:postscript_cmd
        if len(l:feedback)
            echo 'Shell feedback:'
            for l:line in l:feedback
                echo '  ' . l:line
            endfor
        endif
        return 1
    endif
    " print postscript file
    let l:print_cmd = 'kprinter4' . ' ' . shellescape(l:ps_output)
    let l:feedback = systemlist(l:print_cmd)
    if v:shell_error
        echo 'Problem with printing'
        echo 'Command executed was:'
        echo '  ' . l:print_cmd
        if len(l:feedback)
            echo 'Shell feedback:'
            for l:line in l:feedback
                echo '  ' . l:line
            endfor
        endif
    endif
    return v:shell_error
endfunction                                                     " }}}3
" function VrcHighlightLanguages()                                {{{3
" intent: get list of supported highlight languages
" params: nil
" prints: nil
" return: nil
" depend: assumes highlight is available
function! VrcHighlightLanguages()
    let l:cmd = ''
                \ . ' ' . 'highlight --list-scripts=langs'
                \ . ' ' . '|'
                \ . ' ' . 'grep -v ''^$'''
                \ . ' ' . '|'
                \ . ' ' . 'sed ''1d'''
                \ . ' ' . '|'
                \ . ' ' . 'sed ''$d'''
                \ . ' ' . '|'
                \ . ' ' . 'cut -d '':'' -f 2'
                \ . ' ' . '|'
                \ . ' ' . 'sed ''s/([^)]\+)//'''
                \ . ' ' . '|'
                \ . ' ' . 'sed ''s/^ \+//'''
                \ . ' ' . '|'
                \ . ' ' . 'sed ''s/ \+$//'''
    let l:langs = systemlist(l:cmd)
    if v:shell_error
        echo 'Problem getting list of supported highlight languages'
        echo 'Command executed was:'
        echo '  ' . l:cmd
        if len(l:feedback)
            echo 'Shell feedback:'
            for l:line in l:langs
                echo '  ' . l:line
            endfor
        endif
        return
    endif
    return l:langs
endfunction                                                     " }}}3
" function VrcHighlightPostScript(fname)                          {{{3
" intent: create postscript from enscript and print it
" params: 1 - filepath to vim's default postscript output
" prints: feedback
" return: nil
" depend: assumes kprinter4, iconv and enscript are available
" note:   vim handles return values from printing as per v:shell_error
"         that is, boolean values are reversed (1=failure, 0=success)
function! VrcHighlightPostScript(fname)
    " in this function return boolean values are reversed
    " - vim clearly expects return values as per v:shell_error logic
    " ignoring vim's postscript output and creating our own
    call delete(a:fname)
    " get temporary directory name
    let l:tempdir_cmd = 'mktemp --directory'
    let l:tempdir = system(l:tempdir_cmd)
    let l:tempdir = l:tempdir[:-2]    " chomp trailing newline
    if v:shell_error
        echo 'Problem creating temporary directory'
        echo 'Command executed was:'
        echo '  ' . l:tempdir_cmd
        echo 'Shell feedback:'
        echo '  ' . l:tempdir
        return 1
    endif
    " get filepath of postscript output file
    let l:ps_output = l:tempdir . '/texput.ps'
    let l:source = expand('%')
    " generate postscript
    " - highlight generates highlighted latex output
    " - latex generates dvi output from latex
    " - dvips generates postscript output from dvi
" visually appealing styles:
"     bright, edit-gedit, edit-msvs2008, edit-vim, nuvola, peaksea
    let l:postscript_cmd = ''
                \ . ' ' . 'cp'
                \ . ' ' . shellescape(l:source)
                \ . ' ' . shellescape(l:tempdir . '/')
                \ . ' ' . '&&'
                \ . ' ' . 'cd ' . shellescape(l:tempdir)
                \ . ' ' . '&&'
                \ . ' ' . 'highlight'
                \ . ' ' . '--input=' . shellescape(l:source)
    let l:langs = VrcHighlightLanguages()
    if count(l:langs, &filetype)
        let l:postscript_cmd .= ''
                \ . ' ' . '--syntax=' . &filetype
    endif
    let l:postscript_cmd .= ''
                \ . ' ' . '--out-format=latex'
                \ . ' ' . '--doc-title=' . shellescape(l:source)
                \ . ' ' . '--line-length=65'
                \ . ' ' . '--wrap'
                \ . ' ' . '--style=edit-vim'
                \ . ' ' . '|'
                \ . ' ' . 'latex'
                \ . ' ' . '&&'
                \ . ' ' . 'dvips texput.dvi'
    let l:feedback = systemlist(l:postscript_cmd)
    if v:shell_error
        echo 'Problem generating postscript'
        echo 'Command executed was:'
        echo '  ' . l:postscript_cmd
        if len(l:feedback)
            echo 'Shell feedback:'
            for l:line in l:feedback
                echo '  ' . l:line
            endfor
        endif
        return 1
    endif
    " print postscript file
    let l:print_cmd = 'kprinter4' . ' ' . shellescape(l:ps_output)
    let l:feedback = systemlist(l:print_cmd)
    if v:shell_error
        echo 'Problem with printing'
        echo 'Command executed was:'
        echo '  ' . l:print_cmd
        if len(l:feedback)
            echo 'Shell feedback:'
            for l:line in l:feedback
                echo '  ' . l:line
            endfor
        endif
    endif
    return v:shell_error
endfunction                                                     " }}}3
" command PostScriptSource                                        {{{3
" function DnPostScriptSource()                                   {{{4
" intent: select source of postscript: vim's postscript output (has
"         colour syntax) or enscript-generated postscript (has word
"         wrap and colour syntax if language supported by enscript)
" params: nil
" prints: user question and feedback
" return: nil
function! DnPostScriptSource()
    let l:map_choices = {}
    let l:choices_index = 1
    let l:has_choice = 0    " false
    let l:choices = ''
    let l:msg = []
    call add(l:msg, ' ')
    call add(l:msg, 'Checking for methods of generating '
                \ . 'postscript for printing:')
    " vim- and kprinter4-based method
    let l:exes = ['kprinter4']
    if VrcHasExecutables(l:exes)
        call add(l:msg, ' ')
        call add(l:msg, '- available: vim and kprinter4')
        call add(l:msg, '  . has colour syntax')
        call add(l:msg, '  . no word wrapping')
        let l:choices .= "\n&Vim"
        let l:map_choices[l:choices_index] = 'vim'
        let l:choices_index += 1
        let l:has_choice = 1    " true
    else
        call add(l:msg, ' ')
        call add(l:msg, '- NOT available: vim- and kprinter4-based method')
        call add(l:msg, '  . the following tools are all required:')
        call add(l:msg, '    ' . join(l:exes, ', '))
    endif
    " enscript- and kprinter4-based method
    let l:exes = ['enscript', 'kprinter4', 'iconv']
    if VrcHasExecutables(l:exes)
        call add(l:msg, ' ')
        call add(l:msg, '- avilable: enscript and kprinter4')
        call add(l:msg, '  . has word wrap')
        call add(l:msg, '  . has colour syntax if enscript'
                    \     . 'supports filetype')
        let l:choices .= "\n&Enscript"
        let l:map_choices[l:choices_index] = 'enscript'
        let l:choices_index += 1
        let l:has_choice = 1    " true
    else
        call add(l:msg, ' ')
        call add(l:msg, '- NOT available: enscript- and kprinter4-based method')
        call add(l:msg, '  . the following tools are all required:')
        call add(l:msg, '    ' . join(l:exes, ', '))
    endif
    " highlight- and kprinter4-based method
    let l:exes = ['highlight', 'kprinter4', 'latex', 'dvips']
    call extend(l:exes, ['sed', 'grep', 'cut', 'mktemp'])
    if VrcHasExecutables(l:exes)
        call add(l:msg, ' ')
        call add(l:msg, '- avilable: highlight and kprinter4')
        call add(l:msg, '  . has word wrap')
        call add(l:msg, '  . has colour syntax if highlight '
                    \     . 'supports filetype')
        let l:choices .= "\n&Highlight"
        let l:map_choices[l:choices_index] = 'highlight'
        let l:choices_index += 1
        let l:has_choice = 1    " true
    else
        call add(l:msg, ' ')
        call add(l:msg, '- NOT available: highlight- and kprinter4-based method')
        call add(l:msg, '  . the following tools are all required:')
        call add(l:msg, '    ' . join(l:exes, ', '))
    endif
    call add(l:msg, ' ')
    call add(l:msg, 'Postscript generation currently based on: ' 
                    \ . g:dn_ps_source)
    call add(l:msg, ' ')
    for l:line in l:msg
        echo l:line
    endfor
    " choose if choices available
    if l:has_choice
        let l:prompt = 'Select postscript method:'
        let l:choices .= "\n&Cancel"
        let l:choices = strpart(l:choices, 1)
        let l:choice = confirm(l:prompt, l:choices, 0, 'Question')
        if has_key(l:map_choices, l:choice)
            let g:dn_ps_source = l:map_choices[l:choice]
            if     g:dn_ps_source == 'vim'
                set printexpr=VrcUseVimPostScript(v:fname_in)
            elseif g:dn_ps_source == 'enscript'
                set printexpr=VrcEnscriptPostScript(v:fname_in)
            elseif g:dn_ps_source == 'highlight'
                set printexpr=VrcHighlightPostScript(v:fname_in)
            else
                echoerr "Unexpected value of '" . g:dn_ps_source 
                            \ . "' for g:dn_ps_source"
            endif
            call VrcMsg('Current postscript source: ' . g:dn_ps_source, 1)
            execute 'redraw!'
        endif
    else
        echo 'There are no alternative methods currently available'
        echo 'for generating postscript'
    endif
endfunction                                                     " }}}4
command! PostScriptSource call DnPostScriptSource()             " }}}3
" default setting                                                 {{{3
if $VIM_OS == 'unix'
    if executable('kprinter4')
        set printexpr=VrcUseVimPostScript(v:fname_in)
        let g:dn_ps_source = 'vim'
    endif
else
    let g:dn_ps_source = 'default'
endif                                                           " }}}3
                                                                " }}}2

" MISCELLANEOUS:                                                  {{{1
" use of clipboard with copying                                   {{{2
" - all yanked, deleted, changed and pasted text is
"   put into the system clipboard and can be pasted
"   into another vim instance using a vim paste
"   ('unnamed')
" - any visually selected text in vim, or globally-
"   selected text in the windowing system, can be
"   pasted in any vim instance using the windowing
"   system's mechanism; and vice versa in that
"   visually selected text in vim can be pasted into
"   any other application in the windowing system;
"   in X that means any mouse-selected text in any
"   application can be pasted into vim using a
"   mousewheel click or a vim paste, and vice versa
"   ('autoselect')
set clipboard=unnamed,autoselect                                " }}}2
" files to deprioritise when file-matching                        {{{2
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,
            \.ind,.idx,.ilg,.inx,.out,.toc                      " }}}2
" dictionaries                                                    {{{2
if $VIM_OS == 'unix' && filereadable('/usr/share/dict/words')
    set dictionary-=/usr/share/dict/words
    set dictionary+=/usr/share/dict/words
endif                                                           " }}}2
" avoid using shift for ':'                                       {{{2
" ';' synonym for ':': : [N,V]
nnoremap ; :
vnoremap ; :
"                                                                 }}}2
" common typos                                                    {{{2
" :W,:Q,:E [C]
map :W :w
map :Q :q
map :E :e
"                                                                 }}}2
" disable F1 help key                                             {{{2
nnoremap <F1> <Nop>
inoremap <F1> <Nop>
"                                                                 }}}2
" prevent accidentally entering Ex mode                           {{{2
nnoremap <Q> <Nop>
"                                                                 }}}2
" make pasting easier with <F2> toggling paste                    {{{2
set pastetoggle=<F2>
"                                                                 }}}2

" FILETYPE SPECIFIC:                                              {{{1
" c                                                               {{{2
" - map make command to '<Leader>m'
augroup c_files
    au!
    au BufRead,BufNewFile *.c 
                \ echo '-----------------------------------------' |
                \ echo 'You appear to be editing a C source file.' |
                \ echo 'Defining the following mapping(s):'        |
                \ echo '    \m    ->    :make %<    (N,I)'         |
                \ echo '-----------------------------------------' |
                \ inoremap <Leader>m <Esc>:make %<<CR>|
                \ nnoremap <Leader>m :make %<<CR>
augroup END                                                     " }}}2
" configuration files (*.rc)                                      {{{2
" - use template file
augroup config_rc_files
    au!
    au BufRead *.rc call DNU_InsertTemplate('configfile')
    au BufNewFile *.rc call DNU_LoadTemplate('configfile')
augroup END                                                     " }}}2
" configuration files (*.conf)                                    {{{2
" - force file type to 'dosini'
augroup config_conf_files
    au!
    au BufRead,BufNewFile *.conf set ft=dosini
augroup END                                                     " }}}2
" desktop                                                         {{{2
" - use template file
augroup desktop_files
    au!
    au BufRead *.desktop call DNU_InsertTemplate('desktop')
    au BufNewFile *.desktop call DNU_LoadTemplate('desktop')
augroup END                                                     " }}}2
" gnuplot                                                         {{{2
" - force file type to 'gnuplot'
augroup gnuplot_files
    au!
    au BufRead,BufNewFile *.plt set ft=gnuplot
augroup END                                                     " }}}2
" html                                                            {{{2
" - use template file
augroup html_files
    au!
    au BufRead *.html call DNU_InsertTemplate('html')
    au BufNewFile *.html call DNU_LoadTemplate('html')
augroup END                                                     " }}}2
" makefiles                                                       {{{2
" - use template file
augroup make_files
    au!
    au BufRead Makefile.am call DNU_InsertTemplate('makefile.am')
    au BufNewFile Makefile.am call DNU_LoadTemplate('makefile.am')
augroup END                                                     " }}}2
" manpages                                                        {{{2
" - use template file
augroup manpage_files
    au!
    au BufRead *.[0-9] call DNU_InsertTemplate('manpage')
    au BufNewFile *.[0-9] call DNU_LoadTemplate('manpage')
augroup END                                                     " }}}2
" markdown                                                        {{{2
" - use template file and set pandoc templates
" function VrcMarkdownSetup(action)                               {{{3
" intent: setup for markdown file editing
" params: 1 - action ('insert'|'load')
" prints: error message if function not found
" return: boolean
" notes:  inserts or loads markdown file template
"         sets html and latex pandoc templates
function! VrcMarkdownSetup(action)
    set filetype=markdown
    if a:action =~? '^insert$'
        if VrcHasFunction('DNU_InsertTemplate', 'vim-dn-utils')
            call DNU_InsertTemplate('markdown')
        endif
    elseif a:action =~? '^load$'
        if VrcHasFunction('DNU_LoadTemplate', 'vim-dn-utils')
            call DNU_LoadTemplate('markdown')
        endif
    else
        if VrcHasFunction('DNU_Error', 'vim-dn-utils')
            call DNU_Error('Invalid VrcMyTagContext parameter: '. a:action)
        endif
    endif
endfunction                                                     " }}}3
augroup markdown_files
    au!
    au BufReadPost *.md call VrcMarkdownSetup('insert')
    au BufNewFile *.md call VrcMarkdownSetup('load')
augroup END                                                     " }}}2
" perl module                                                     {{{2
" - use template file
augroup perl_module_files
    au!
    au BufRead *.pm call DNU_InsertTemplate('perlmod')
    au BufNewFile *.pm call DNU_LoadTemplate('perlmod')
augroup END                                                     " }}}2
" perl script                                                     {{{2
" - use template file
augroup perl_script_files
    au!
    au BufRead *.pl call DNU_InsertTemplate('perlscript')
    au BufNewFile *.pl call DNU_LoadTemplate('perlscript')
augroup END                                                     " }}}2
" nsis script headers                                             {{{2
" - script files ('*.nsi') are automatically detected by vim
"   as filetype 'nsis'
" - script headers ('*.nsh') are not, hence this autocommand group
augroup nsis_script_header_files
    au!
    au BufRead,BufNewFile *.nsh set filetype=nsis
augroup END                                                     " }}}2
" reportbug                                                       {{{2
" - debian bug reporting mechanism
" - force file type to 'mail'
augroup reportbug_files
    au!
    au BufRead reportbug.* set ft=mail
    au BufRead reportbug-* set ft=mail
augroup END                                                     " }}}2
" shellscript                                                     {{{2
" - use template file
augroup shellscript_files
    au!
    au BufRead *.sh call DNU_InsertTemplate('shellscript')
    au BufNewFile *.sh call DNU_LoadTemplate('shellscript')
augroup END                                                     " }}}2
" txt2tags                                                        {{{2
" - use syntax highlighting
augroup txt2tag_files
    au!
    au BufRead,BufNewFile *.t2t set ft=txt2tags
augroup END                                                     " }}}2
" vim                                                             {{{2
" - use vim ':help' for 'K' help
augroup vim_files
    au!
    au BufReadPost .vim setlocal keywordprg=''
augroup END                                                     " }}}2
" vimrc                                                           {{{2
" - reload after changing
" - use vim ':help' for 'K' help
augroup vimrc_files
    au!
    au BufWritePost .vimrc source %
    au BufReadPost .vimrc setlocal keywordprg=''
augroup END                                                     " }}}2
" xhtml                                                           {{{2
" - use template file
augroup xhtml_files
    au!
    au BufRead *.xhtml call DNU_InsertTemplate('xhtml')
    au BufNewFile *.xhtml call DNU_LoadTemplate('xhtml')
augroup END                                                     " }}}2
                                                                " }}}1
" vim: set foldmethod=marker :
