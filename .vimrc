" UTILITY FUNCTIONS:                                                 " {{{1
" only functions used in multiple subsidiary configuration files
" function VrcOS()                                                     {{{2
" intent: determine operating system
" params: nil
" prints: nil
" return: string ('windows'|'unix'|'other')
function! VrcOS()
    if has('win32') || has ('win64') || has('win95') || has('win32unix')
        return 'windows'
    elseif has('unix')
        return 'unix'
    else
        return 'other'
    endif
endfunction                                                          " }}}2
" function VrcVimHome()                                                {{{2
" intent: determine vim home directory
" params: nil
" prints: nil
" return: string (directory path)
function! VrcVimHome()
    let l:os   = VrcOS()
    let l:home = escape($HOME, ' ')
    if     l:os ==# 'windows'
        return l:home . '/vimfiles'
    elseif l:os ==# 'unix'
        return l:home . '/.vim'
    else
        return l:home . '/.vim'
    endif
endfunction                                                          " }}}2

" PLUGINS:                                                             {{{1
" using github.com/shougo/dein.vim
" dein requirements                                                    {{{2
" - required tools: rsync, git                                         {{{3
for app in ['rsync', 'git']
    if ! executable(app)
        echoerr "plugin handler 'dein' can't find '" . app . "'"
        echoerr 'aborting vim configuration file execution'
        finish
    endif
endfor
" - required settings                                                  {{{3
"   vint: -ProhibitSetNoCompatible
set nocompatible
filetype off
" - required vim version                                               {{{3
if v:version < 704
    echoerr 'this instance of vim is version' . v:version
    echoerr "plugin handler 'dein' needs vim 7.4+"
    echoerr 'aborting vim configuration file execution'
    finish
endif
" how to install/update plugins with dein                              {{{2
" - install new plugins
"   . in vim : call dein#install()
"   . shell  : vim "+call dein#install()" +qall
" - update all plugins
"   . in vim : call dein#update()
"   . shell  : vim "+call dein#update()" +qall
" set plugin directories                                               {{{2
let s:plugins_dir = expand('~/.cache/dein')
function! VrcPluginsDir()
    return s:plugins_dir
endfunction
let s:dein_dir = s:plugins_dir . '/repos/github.com/shougo/dein.vim'
" ensure dein is installed                                             {{{2
if !isdirectory(s:dein_dir)
    execute '!git clone https://github.com/shougo/dein.vim' s:dein_dir
endif
" load dein                                                            {{{2
if &runtimepath !~# '/dein.vim'
    execute 'set runtimepath^=' . s:dein_dir
endif
call dein#begin(s:plugins_dir)
call dein#add('shougo/dein.vim')
" dein commands                                                        {{{2
call dein#add('haya14busa/dein-command.vim', {
            \ 'on_cmd' : ['Dein'],
            \ })
" bundles: utilities                                                   {{{2
" - vimproc : asynchronous execution                                   {{{3
call dein#add('shougo/vimproc.vim', {
            \ 'build' : 'make',
            \ })
" - dn-utils : general utilities                                       {{{3
call dein#add('dnebauer/vim-dn-utils')
" - repeat : plugin helper for repeating commands                      {{{3
call dein#add('tpope/vim-repeat', {
            \ 'lazy' : 1,
            \ })
" - context_filetype : plugin helper                                   {{{3
call dein#add('shougo/context_filetype.vim', {
            \ 'lazy': 1,
            \ })
" bundles: shell integration                                           {{{2
" - vimshell : shell emulation                                         {{{3
call dein#add('shougo/vimshell.vim', {
            \ 'depends' : 'vimproc.vim',
            \ 'on_cmd'  : ['VimShell',           'VimShellCreate',
            \              'VimShellTab',        'VimShellPop',
            \              'VimShellCurrentDir', 'VimShellBufferDir',
            \              'VimShellExecute',    'VimShellInteractive',
            \              'VimShellSendString', 'VimShellSendBuffer',
            \              'VimShellClose'],
            \ })
" - file-line : open vim on given line                                 {{{3
call dein#add('bogado/file-line')
" - superman : shell uses vim as manpage viewer                        {{{3
call dein#add('dnebauer/vim-superman', {
            \ 'if' : 'has("unix")',
            \ })
" - eunuch : unix shell commands as vim commands                       {{{3
"   . disable plugin-set autocommands after sourcing because they
"     a) make all new files executable (not desirable), and
"     b) insert templates into new files (conflicts with
"        vim-dn-utils templates)
call dein#add('tpope/vim-eunuch', {
            \ 'if'               : 'has("unix")',
            \ 'on_cmd'           : ['Remove',    'Unlink', 'Move',
            \                       'Rename',    'Chmod',  'Mkdir',
            \                       'Find',      'Locate', 'Wall',
            \                       'SudoWrite', 'SudoEdit'],
            \ 'hook_post_source' :  'augroup! eunuch',
            \ })
" - vimpager : unix shell uses vim as pager                            {{{3
"   . sets shell PAGER variable to use vim
"   . sets alias 'less' to $PAGER
cal dein#add('rkitover/vimpager', {
            \ 'if'     : 'has("unix")',
            \ 'on_cmd' : ['Page'],
            \ })
" bundles: editing                                                     {{{2
" - unimpaired : various paired mappings                               {{{3
call dein#add('tpope/vim-unimpaired', {
            \ 'depends' : ['vim-repeat'],
            \ })
" - surround : delete/change surrounding parens, etc.                  {{{3
call dein#add('tpope/vim-surround', {
            \ 'depends' : ['vim-repeat'],
            \ })
" - commentary : comment and uncomment lines                           {{{3
call dein#add('tpope/vim-commentary', {
            \ 'on_cmd' : ['Commentary', 'CommentaryLine',
            \             'ChangeCommentary'],
            \ 'on_map' : {'x': ['gc'],
            \             'n': ['gc', 'gcc', 'cgc', 'gcu'],
            \             'o': ['gc']},
            \ })
" - endwise : automatically end structures like if..endif              {{{3
call dein#add('tpope/vim-endwise')
" - gundo : undo tree                                                  {{{3
call dein#add('sjl/gundo.vim', {
            \ 'on_cmd' : ['GundoToggle'],
            \ })
" - DeleteTrailingWhitespace : delete trailing whitespace              {{{3
call dein#add('vim-scripts/DeleteTrailingWhitespace')
" bundles: searching and finding                                       {{{2
" - nerdtree : tree explorer                                           {{{3
call dein#add('scrooloose/nerdtree', {
            \ 'on_cmd' : ['NERDTree', 'NERDTreeToggle'],
            \ })
" - nerdtree-git-plugun : show file git status                         {{{3
call dein#add('xuyuanp/nerdtree-git-plugin', {
            \ 'if' : 'executable("git")',
            \ })
" - ack : search tool                                                  {{{3
call dein#add('mileszs/ack.vim', {
            \ 'if'     : 'executable("ack")',
            \ 'on_cmd' : ['Ack', 'AckAdd', 'LAck', 'LAckAdd'],
            \ })
" - ag : search tool                                                   {{{3
call dein#add('ervandew/ag', {
            \ 'if'     : 'executable("Ag")',
            \ 'on_cmd' : ['Ag'],
            \ })
" - unite : integrated information display                             {{{3
call dein#add('shougo/unite.vim')
" - neomru : unite helper - recently used files                        {{{3
call dein#add('shougo/neomru.vim', {
            \ 'on_source' : ['unite.vim'],
            \ })
" bundles: internet                                                    {{{2
" - vim-g : google lookup                                              {{{3
call dein#add('szw/vim-g', {
            \ 'if'     : 'executable("perl")',
            \ 'on_cmd' : ['Google', 'Googlef'],
            \ })
" - webapi : web browser API                                           {{{3
call dein#add('mattn/webapi-vim', {
            \ 'lazy' : 1,
            \ })
" - quicklink : md-specific web lookup and link inserter               {{{3
call dein#add('christoomey/vim-quicklink', {
            \ 'on_ft'   : ['markdown', 'markdown.pandoc'],
            \ 'depends' : ['webapi-vim'],
            \ })
" - open-browser : open uri in browser                                 {{{3
call dein#add('tyru/open-browser.vim', {
            \ 'on_cmd' : ['OpenBrowser', 'OpenBrowserSearch',
            \             'OpenBrowserSmartSearch'],
            \ 'on_map' : {'n': ['<Plug>(openbrowser-smart-search)'],
            \             'v': ['<Plug>(openbrowser-smart-search)']},
            \ })
" - whatdomain : look up top level domain                              {{{3
call dein#add('whatdomain.vim', {
            \ 'on_cmd'  : ['WhatDomain'],
            \ 'on_func' : ['WhatDomain'],
            \ })
" bundles: printing                                                    {{{2
" - dn-print-dialog : pure vim print dialog                            {{{3
call dein#add('dnebauer/vim-dn-print-dialog', {
            \ 'on_cmd' :  ['PrintDialog'],
            \ })
" bundles: calendar                                                    {{{2
" - calendar : display calendar                                        {{{3
call dein#add('mattn/calendar-vim', {
            \ 'on_cmd' : ['Calendar', 'CalendarH', 'CalendarT'],
            \ })
" bundles: completion                                                  {{{2
" - deoplete : nvim completion engine                                  {{{3
call dein#add('shougo/deoplete.nvim', {
            \ 'depends'     : ['context_filetype.vim'],
            \ 'if'          : 'has("nvim")',
            \ 'on_event'    : 'InsertEnter',
            \ 'build'       : 'pip3 install --upgrade neovim',
            \ 'hook_source' : join([
            \                 'let g:deoplete#enable_at_startup = 1',
            \                 ], "\n"),
            \ })
" - neocomplete : vim completion engine                                {{{3
call dein#add('shougo/neocomplete.vim', {
            \ 'depends'     : ['context_filetype.vim'],
            \ 'if'          : '     v:version >= 704'
            \               . ' &&  !has("nvim")'
            \               . ' &&  has("lua")',
            \ 'hook_source' : join([
            \                 'let g:neocomplete#enable_at_startup = 1',
            \                 ], "\n"),
            \ })
" - neoinclude : completion framework helper                           {{{3
call dein#add('shougo/neoinclude.vim', {
            \ 'on_source' : ['neocomplete.vim', 'deoplete.nvim'],
            \ })
" - neco-syntax : completion syntax helper                             {{{3
call dein#add('shougo/neco-syntax', {
            \ 'on_source' : ['neocomplete.vim', 'deoplete.nvim'],
            \ })
" - neco-vim : completion source helper                                {{{3
call dein#add('shougo/neco-vim', {
            \ 'on_ft' : ['vim'],
            \ })
" - echodoc : plugin helper that prints to echo area                   {{{3
call dein#add('shougo/echodoc.vim', {
            \ 'depends'     : ['context_filetype.vim'],
            \ 'on_event'    : ['CompleteDone'],
            \ 'hook_source' : join([
            \                 'let g:echodoc_enable_at_startup = 1',
            \                 'set cmdheight=2',
            \                 ], "\n"),
            \ })
" - neopairs : completion helper closes paired structures              {{{3
call dein#add('shougo/neopairs.vim', {
            \ 'on_source' : ['neocomplete.vim', 'deoplete.nvim'],
            \ 'if'        : '     v:version >= 704'
            \             . ' &&  has("patch-7.4.774")',
            \ })
" - perlomni : perl completion                                         {{{3
call dein#add('c9s/perlomni.vim', {
            \ 'if'        : 'v:version >= 702',
            \ 'on_ft'     : ['perl'],
            \ })
" - delimitMate : completion helper closes paired syntax               {{{3
call dein#add('raimondi/delimitMate', {
            \ 'on_event' : 'InsertEnter',
            \ })
" bundles: snippets                                                    {{{2
" - neonippet : snippet engine                                         {{{3
call dein#add('shougo/neosnippet.vim', {
            \ 'depends'  : ['context_filetype.vim'],
            \ 'on_event' : 'InsertCharPre',
            \ })
" - snippets : snippet library                                         {{{3
call dein#add('honza/vim-snippets', {
            \ 'on_source' : ['neosnippet.vim'],
            \ })
" bundles: formatting                                                  {{{2
" - tabular : align text                                               {{{3
call dein#add('godlygeek/tabular', {
            \ 'on_cmd' : ['Tabularize', 'AddTabularPattern',
            \             'AddTabularPipeline'],
            \ })
" - splitjoin : single <-> multi-line statements                       {{{3
call dein#add('andrewradev/splitjoin.vim', {
            \ 'on_cmd' : ['SplitjoinSplit', 'SplitjoinJoin'],
            \ 'on_map' : {'n': ['gS', 'gJ']},
            \ })
" bundles: spelling, grammar, word choice                              {{{2
" - dict : online dictionary (dict client)                             {{{3
call dein#add('szw/vim-dict', {
            \ 'on_cmd' : ['Dict'],
            \ })
" - grammarous : grammar checker                                       {{{3
call dein#add('rhysd/vim-grammarous', {
            \ 'depends' : ['unite.vim'],
            \ 'on_cmd'  : ['GrammarousCheck', 'GrammarousReset',
            \              'Unite grammarous'],
            \ })
" - online-thesaurus : online thesaurus                                {{{3
call dein#add('beloglazov/vim-online-thesaurus', {
            \ 'on_cmd' : ['Thesaurus', 'OnlineThesaurusCurrentWord'],
            \ })
" - abolish : word replace and format variable names                   {{{3
call dein#add('tpope/vim-abolish', {
            \ 'on_cmd' : ['Abolish', 'Subvert'],
            \ 'on_map' : {'n': ['crc', 'crm', 'cr_', 'crs', 'cru',
            \                   'crU', 'cr-', 'crk', 'cr.']},
            \ })
" bundles: keyboard navigation                                         {{{2
" - hardmode : restrict navigation keys                                {{{3
call dein#add('wikitopian/hardmode', {
            \ 'on_func' : ['HardMode', 'EasyMode'],
            \ })
" - matchit : jump around matched structures                           {{{3
call dein#add('vim-scripts/matchit.zip')
" - sneak : two-character motion plugin                                {{{3
call dein#add('justinmk/vim-sneak')
" bundles: ui                                                          {{{2
" - headlights : integrate plugins with vim menus                      {{{3
call dein#add('mbadran/headlights', {
            \ 'if' : '     v:version >= 700'
            \      . ' &&  has("python")'
            \      . ' &&  executable("python")',
            \ })
" - airline : status line                                              {{{3
call dein#add('vim-airline/vim-airline', {
            \ 'if'          : 'v:version >= 702',
            \ 'hook_source' :
\        join([
\            'let g:airline#extensions#branch#enabled = 1',
\            'let g:airline#extensions#branch#empty_message = ""',
\            'let g:airline#extensions#branch#displayed_head_limit = 10',
\            'let g:airline#extensions#branch#format = 2',
\            'let g:airline#extensions#syntastic#enabled = 1',
\            'let g:airline#extensions#tagbar#enabled = 1',
\        ], "\n"),
            \ })
" - airline-themes : airline helper                                    {{{3
call dein#add('vim-airline/vim-airline-themes', {
            \ 'depends' : 'vim-airline',
            \ })
" - tagbar : outline viewer                                            {{{3
call dein#add('majutsushi/tagbar', {
            \ 'if'     : '     v:version >= 701'
            \          . ' &&  executable("ctags")',
            \ 'on_cmd' : ['TagbarOpen',          'TagbarClose',
            \             'TagbarToggle',        'Tagbar',
            \             'TagbarOpenAutoClose', 'TagbarTogglePause',
            \             'TagbarSetFoldLevel',  'TagbarShowTag',
            \             'TagbarCurrentTag',    'TagbarGetTypeConfig',
            \             'TagbarDebug',         'TagbarDebugEnd'],
            \ })
" - [various] : colour schemes                                         {{{3
call dein#add('atelierbram/vim-colors_atelier-schemes')  " atelier
call dein#add('sjl/badwolf')                             " bad wolf
call dein#add('w0ng/vim-hybrid')                         " hybrid
call dein#add('jonathanfilip/vim-lucius')                " lucius
call dein#add('nlknguyen/papercolor-theme')              " papercolor
call dein#add('peaksea')                                 " peaksea
call dein#add('vim-scripts/print_bw.zip')                " print_bw
call dein#add('jpo/vim-railscasts-theme')                " railscast
call dein#add('altercation/vim-colors-solarized')        " solarized
call dein#add('jnurmine/zenburn', {
            \ 'if' : '     v:version >= 704'
            \      . ' &&  has("patch-7.4.1826")',
            \ })                                         " zenburn
" - terminus : enhance terminal integration                            {{{3
call dein#add('wincent/terminus', {
            \ 'if' : '!has("gui")'
            \ })
" - numbers : number <->relativenumber switching                       {{{3
call dein#add('myusuf3/numbers.vim')
" bundles: syntax checking                                             {{{2
" - syntastic : syntax checker for vim                                 {{{3
call dein#add('scrooloose/syntastic', {
            \ 'if' : '!has("nvim")',
            \ })
" - neomake : asynchronous syntax checker for nvim                     {{{3
call dein#add('neomake/neomake', {
            \ 'if'     : 'has("nvim")',
            \ 'on_cmd' : ['Neomake'],
            \ })
" bundles: tags                                                        {{{2
" - easytags : automated tag generation                                {{{3
call dein#add('xolox/vim-easytags', {
            \ 'if'      : 'executable("ctags")',
            \ 'depends' : ['vim-shell', 'vim-misc'],
            \ })
" - shell : asynchronous operations in ms windows                      {{{3
call dein#add('xolox/vim-shell', {
            \ 'lazy' : 1,
            \ })
" - misc : plugin library used by other scripts                        {{{3
call dein#add('xolox/vim-misc', {
            \ 'lazy'    : 1,
            \ })
"           - fails in git-bash/MinTTY with error:
"             'Failed to read temporary file...'
" bundles: version control                                             {{{2
" - gitgutter : git giff symbols in gutter                             {{{3
call dein#add('airblade/vim-gitgutter', {
            \ 'if' : '    executable("git")'
            \      . '&&  ('
            \      . '      ('
            \      . '            has("vim")'
            \      . '        &&  v:version > 704'
            \      . '        &&  has("patch-7.4.1826")'
            \      . '      )'
            \      . '      ||'
            \      . '      has("nvim")'
            \      . '    )',
            \ })
" - fugitive : git integration                                         {{{3
call dein#add('tpope/vim-fugitive', {
            \ 'if' : 'executable("git")',
            \ })
" bundles: docbook support                                             {{{2
" - jhradilek/vim-snippets : NOT installed using dein                  {{{3
"   . because its default location clashes with honza/vim-snippets
"   . instead installed to custom location by ftplugin vim-dn-docbk
" - docbk : docbook support                                            {{{3
call dein#add('jhradilek/vim-docbk', {
            \ 'on_ft' : ['docbk'],
            \ })
" - dn-docbk : docbook support                                         {{{3
call dein#add('dnebauer/vim-dn-docbk', {
            \ 'on_ft' : ['docbk'],
            \ })
" bundles: html support                                                {{{2
" - html5 : html5 support                                              {{{3
call dein#add('othree/html5.vim', {
            \ 'on_ft' : ['html'],
            \ })
" - sparkup : condensed html parser                                    {{{3
call dein#add('rstacruz/sparkup', {
            \ 'on_ft' : ['html'],
            \ })
" - emmet : expand abbreviations                                       {{{3
call dein#add('mattn/emmet-vim', {
            \ 'on_ft' : ['html', 'css'],
            \ })
" bundles: javascript support                                          {{{2
" - tern + jcstags : javascript tag generator                          {{{3
" - jsctags install details                                            {{{4
"   . provides tag support for javascript
"   . is installed by npm as binaries
"     - npm requires node.js which is no longer supported on cygwin
"     - so cannot install jsctags on cygwin
"   . requires tern_for_vim
"   . is reinstalled whenever tern is updated - see tern install next
"   . npm install command used below assumes npm is configured to
"     install in global mode without needing superuser privileges
" - tern install details                                               {{{4
"   . is installed by npm
"     - npm requires node.js which is no longer supported on cygwin
"     - so cannot install tern on cygwin
"   . npm install command used below assumes npm is configured to
"     install in global mode without needing superuser privileges
"   . update of tern is used as trigger to reinstall jsctags
function! VrcBuildTernAndJsctags()                                   " {{{4
    call VrcBuildTern()
    call VrcBuildJsctags()
endfunction
function! VrcBuildTern()                                             " {{{4
    let l:feedback = system('npm install')
    if v:shell_error
        echoerr 'Unable to build tern-for-vim plugin'
        if strlen(l:feedback) > 0
            echoerr 'Error message: ' . l:feedback
        endif
    endif
endfunction
function! VrcBuildJsctags()                                          " {{{4
    let l:cmd = 'npm install -g ' .
                \ 'git+https://github.com/ramitos/jsctags.git'
    unlet l:feedback
    let l:feedback = system(l:cmd)
    if v:shell_error
        echoerr 'Unable to install jsctags binaries'
        if strlen(l:feedback) > 0
            echoerr 'Error message: ' . l:feedback
        endif
    endif
endfunction
function! VrcCygwin()                                                " {{{4
    return system('uname -o') =~# '^Cygwin'
endfunction
" - install                                                            {{{4
"   . cannot test for cygwin in dein#add 'if' statement
"   . doing so results in 'E48: Not allowed in sandbox
if !VrcCygwin()
    call dein#add('ternjs/tern_for_vim', {
                \ 'if'               : '!has("nvim")',
                \ 'on_ft'            : ['javascript'],
                \ 'hook_post_update' : function('VrcBuildTernAndJsctags'),
                \ })
    call dein#add('carlitux/deoplete-ternjs', {
                \ 'if'               : 'has("nvim")',
                \ 'on_ft'            : ['javascript'],
                \ 'depends'          : ['deoplete.nvim'],
                \ 'hook_source'      :
                \            join([
                \                'let g:tern_request_timeout       = 1',
                \                'let g:tern_show_signature_in_pum = 0',
                \            ], "\n"),
                \ 'hook_post_update' : 'npm install -g tern',
                \ })
endif
" bundles: latex support                                               {{{2
" - vimtex : latex support                                             {{{3
call dein#add('lervag/vimtex', {
            \ 'on_ft' : ['tex','latex'],
            \ })
" - dn-latex : latex support                                           {{{3
call dein#add('dnebauer/vim-dn-latex', {
            \ 'on_ft' : ['tex','latex'],
            \ })
" bundles: markdown support                                            {{{2
" - markdown2ctags : tag generator                                     {{{3
call dein#add('jszakmeister/markdown2ctags', {
            \ 'on_ft' : ['markdown','markdown.pandoc'],
            \ })
" - dn-markdown : md support                                           {{{3
call dein#add('dnebauer/vim-dn-markdown', {
            \ 'on_ft' : ['markdown','markdown.pandoc'],
            \ })
" - previm : realtime preview                                          {{{3
call dein#add('kannokanno/previm', {
            \ 'on_ft'   : ['markdown','markdown.pandoc'],
            \ 'depends' : ['open-browser.vim'],
            \ 'on_cmd'  : ['PrevimOpen'],
            \ })
" bundles: perl support                                                {{{2
" - perl : perl support                                                {{{3
call dein#add('vim-perl/vim-perl', {
            \ 'on_ft' : ['perl'],
            \ })
" - dn-perl : perl support                                             {{{3
call dein#add('dnebauer/vim-dn-perl', {
            \ 'on_ft' : ['perl'],
            \ })
" - perlhelp : provide help with perldoc                               {{{3
call dein#add('perlhelp.vim', {
            \ 'if'    : 'executable("perldoc")',
            \ 'on_ft' : ['perl'],
            \ })
" bundles: php support                                                 {{{2
" - phpctags : tag generation                                          {{{3
"   . cannot test for cygwin in dein#add 'if' statement
"   . doing so results in 'E48: Not allowed in sandbox
if !VrcCygwin()
    call dein#add('vim-php/tagbar-phpctags.vim', {
                \ 'on_ft' : ['php'],
                \ 'build' : 'make',
                \ })
    "           build 'phpctags' executable
    "           build fails in cygwin
endif
" bundles: python support                                              {{{2
"  - jedi : autocompletion                                             {{{3
call dein#add('davidhalter/jedi-vim', {
            \ 'if'               : '!has("nvim")',
            \ 'on_ft'            : ['python'],
            \ 'hook_post_update' : 'pip install --upgrade jedi',
            \ })
" - deoplete-jedi : deoplete helper                                    {{{3
call dein#add('zchee/deoplete-jedi', {
            \ 'if'               : '!has("nvim")',
            \ 'on_ft'            : ['python'],
            \ 'depends'          : ['deoplete.nvim'],
            \ 'hook_post_update' : 'pip install --upgrade jedi',
            \ })
" - pep8 : indentation support                                         {{{3
call dein#add('hynek/vim-python-pep8-indent', {
            \ 'on_ft' : 'python',
            \ })
" bundles: tmux support                                                {{{2
" navigator : split navigation                                         {{{3
call dein#add('christoomey/vim-tmux-navigator')
" tmux : tmux.conf support                                             {{{3
call dein#add('tmux-plugins/vim-tmux', {
            \ 'on_ft' : ['tmux'],
            \ })
" bundles: xml support                                                 {{{2
" - xml : xml support                                                  {{{3
call dein#add('xml.vim', {
            \ 'on_ft' : ['xml'],
            \ })
" bundles: xquery support                                              {{{2
" indentomnicomplete : autoindent and omnicomplete                     {{{3
call dein#add('XQuery-indentomnicompleteftplugin', {
            \ 'on_ft' : ['xquery'],
            \ })
" close dein                                                           {{{2
call dein#end()
" required settings                                                    {{{2
filetype on
filetype plugin on
filetype indent on
syntax enable
" call post-source hooks                                               {{{2
augroup dein_config
    autocmd!
    autocmd VimEnter * call dein#call_hook('post_source')
augroup END
" install new bundles on startup                                       {{{2
if dein#check_install()
    call dein#install()
endif

" SUBSIDIARY CONFIGURATION FILES:                                    " {{{1
for conf_file in glob(VrcVimHome() . '/rc/*.vim', 0, 1)
    execute 'source' conf_file
endfor

" FINAL CONFIGURATION:                                                 {{{1
" set filetype to 'text' if not known                                  {{{2
augroup vrc_unknown_files
    autocmd!
    autocmd BufEnter *
                \ if &filetype == "" |
                \   setlocal ft=text |
                \ endif
augroup END                                                          " }}}2

" vim: set foldmethod=marker :
