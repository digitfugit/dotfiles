"
"
" My vimrc
"
" " Configuracion interface {{{
set nocompatible            " TODO

set tabstop=4               " Tabulacion a 4
set softtabstop=4
set softtabstop=4
set shiftwidth=4

set noswapfile              " Control con git o lo que sea

set expandtab               " Transforma tabs to espacios
set number                  " Muestar numeros de linea
set showcmd                 " Muestra el ultimo comando abajo a la derecha
set cursorline              " Resalta la linea actual
set hidden                  " Puedo cambiar de buffer sin grabar
set relativenumber          " Para mejorar los saltos con j y k

""filetype plugin indent on   " Indenta automaticamente en funcion del filetype
"filetype off   " Indenta automaticamente en funcion del filetype

set wildmenu                " autocompletado visual para comandos
set wildmode=longest:list,full   " feo, pero mas comodo para mi


set lazyredraw              " solo redibuja cuando hace falta

set showmatch               " muestra parejas de ([{

set ignorecase              " mejor busqueda
set smartcase
"}}}
" Configuracion busquedas {{{
" ---------------------------------------------------------
"
set incsearch               " muestra las busquedas segun se teclea
set hlsearch                " resalta resultados de la busqueda
nohlsearch
" Pulsar dos veces escape borra el resaltado de los resultados de busqueda
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>
"}}}
" Configuracion folding {{{
" ---------------------------------------------------------
"
set foldlevelstart=10       " Inicialmente abre carpetas hasta 10 niveles
set foldmethod=marker       " Setea metodo para las folds 
map ,f :set foldmethod=indent<cr>zM<cr>
map ,F :set foldmethod=manual<cr>zr<cr>
"}}}
" Configuracion movimiento {{{ -------------------------------------------

" El raton algunas veces esta bien
set mouse=a
nmap <RightMouse> :set paste<cr>"+gP:set nopaste<cr>

" Scroll mas rapido
nnoremap J 5j
nnoremap L 5l

" Cambio de buffers
nnoremap L :bnext<cr>
nnoremap H :bprev<cr>

" Mapeo lider y su timeout para anular
let mapleader=','
let maplocalleader= ' '
set timeoutlen=400

augroup AusNavegacion
    autocmd!
    " Navegacion en help con <enter> (C-] no es comodo con teclado espanol
    autocmd filetype help :nnoremap <buffer><CR> <c-]>
augroup END

" Mueve al principio linea
function! MichiGoFirstColum()
    let pos = getpos(".")
    :normal ^
    if pos[2] == getpos(".")[2]
        let pos[2]=0
        call setpos(".",pos)
    endif
endfunction
nnoremap <silent> 0 :call MichiGoFirstColum()<CR>

" Mejorar algunas teclas dificiles de pulsar en espanol
nnoremap ñ :
"nnoremap : <nop>
nnoremap - /
"nnoremap / <nop>

" Grabar mas facil con ,, y salir con ,.
noremap <leader><leader> <Esc>:w<Enter>
noremap <leader>. <Esc>:wall<Enter>:q<Enter>
imap <leader><leader> <Esc>:w<Enter>
imap <leader>. <Esc>:wall<Enter>:q<Enter>

 " Cambio rápido entre ventanas {{{
 nnoremap <C-h> <C-w>h
 nnoremap <C-j> <C-w>j
 nnoremap <C-k> <C-w>k
 nnoremap <C-l> <C-w>l
 " }}}   
" ranger como explorador de archivos {{{
" compatible with ranger 1.4.2 through 1.7.*
"
" Add ranger as a file chooser in vim
"
" If you add this code to the .vimrc, ranger can be started using the command
" ":RangerChooser" or the keybinding "<leader>r".  Once you select one or more
" files, press enter and ranger will quit again and vim will open the selected
" files.

function! RangeChooser()
    let temp = tempname()
    " The option "--choosefiles" was added in ranger 1.5.1. Use the next line
    " with ranger 1.4.2 through 1.5.0 instead.
    "exec 'silent !ranger --choosefile=' . shellescape(temp)
    if has("gui_running")
        exec 'silent !xterm -e ranger --choosefiles=' . shellescape(temp)
    else
        exec 'silent !ranger --choosefiles=' . shellescape(temp)
    endif
    if !filereadable(temp)
        redraw!
        " Nothing to read.
        return
    endif
    let names = readfile(temp)
    if empty(names)
        redraw!
        " Nothing to open.
        return
    endif
    " Edit the first item.
    exec 'edit ' . fnameescape(names[0])
    " Add any remaning items to the arg list/buffer list.
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!
endfunction
command! -bar RangerChooser call RangeChooser()
" TODO: decidir vimfiler o ranger
"nnoremap <leader>r :<C-U>RangerChooser<CR>

" }}}

"}}} ---------------------------------------------------------------------

" Cosas varias 
" Vuelve a leer configuracion cuando cambia vimrc
augroup MisAutocmd
    autocmd!
    autocmd BufWritePost .vimrc source %
    " !autocmd ....
augroup END

"}}} ---------------------------------------------------------------------

" Autoinstalacion y configuracion de NeoBundle {{{
" se necesita tener instalado git

" Autoinstalando NeoBundle
let iCanHazNeoBundle=1
let neobundle_readme=expand($HOME.'/.vim/bundle/neobundle.vim/README.md')
if !filereadable(neobundle_readme)
    echo "Installing NeoBundle.."
    echo ""
    silent !mkdir -p $HOME/.vim/bundle
    silent !git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
    let iCanHazNeoBundle=0
endif

" Instrucciones del readme de neobundle
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

" Required:
" filetype plugin indent on

" Instalando los plugins por primera vez
if iCanHazNeoBundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :NeoBundleInstall
endif
" }}}


" Plugins controlados por NeoBundle {{{


NeoBundle "kien/ctrlp.vim"       "CtrlP - Buscador de ficheros fuzzy
NeoBundle 'vimwiki/vimwiki'      " Mi wikipedia personal
NeoBundle 'scrooloose/syntastic' " Syntax checking hacks for vim
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'bling/vim-airline'

NeoBundle 'SirVer/ultisnips'     " Snippets
NeoBundle 'honza/vim-snippets'     " Snippets


NeoBundle 'Shougo/unite.vim'        " La madre de todos los plugins
" Cosas de unite
NeoBundle 'Shougo/vimfiler.vim'     " Un explorador de archivos
NeoBundle 'Shougo/neomru.vim', {'autoload':{'unite_sources':
            \ 'colorscheme'}}   " Fuente de mru
NeoBundleLazy 'ujihisa/unite-colorscheme', {'autoload':{'unite_sources':
            \ 'colorscheme'}}   " Fuente de esquemas de color
" Esquemas de color {{{

" Temas Oscuros
" Versión de molokai mejorada para terminal, casi identica a la de GUI
NeoBundle 'joedicastro/vim-molokai256'

NeoBundle 'tomasr/molokai'
NeoBundleLazy 'sjl/badwolf', { 'autoload' : { 'unite_sources' : 'colorscheme', }}
NeoBundleLazy 'nielsmadan/harlequin', { 'autoload' : { 'unite_sources' : 'colorscheme', }}


" Temas claros
NeoBundleLazy 'vim-scripts/summerfruit256.vim', { 'autoload' : { 'unite_sources' : 'colorscheme', }}
NeoBundleLazy 'joedicastro/vim-github256', { 'autoload' : { 'unite_sources' : 'colorscheme', }}
" }}} Esquemas de color


" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.

call neobundle#end()
NeoBundleCheck

filetype plugin indent on
" }}}

" Mappings y configuracion de plugins {{{
" Unite {{{

" menus {{{
let g:unite_source_menu_menus = {}

" tecla prefijo para menus (se usa para todos los menus de Unite) {{{
nnoremap [menu] <Nop>
nmap <LocalLeader> [menu]
" }}}

" menu menus
nnoremap <silent>[menu]u :Unite -silent -winheight=20 menu<CR>

" menu esqueleto {{{
" let g:unite_source_menu_menus.esqueleto = {'esqueleto'     '      esqueleto                                     
" menu archivos y directorios {{{
let g:unite_source_menu_menus.archivos = { 'description' : '       archivos y directorios                       ⌘ [espacio]o', }
let g:unite_source_menu_menus.archivos.command_candidates = [
    \['▷ abrir archivo                                              ⌘ ,o', 'Unite -start-insert file'],
    \['▷ abrir archivo reciente                                     ⌘ ,m', 'Unite file_mru'],
    \['▷ abrir archivo con busqueda recursiva',                     'Unite -start-insert file_rec/async'],
    \['▷ crear nuevo archivo',                                      'Unite file/new'],
    \['▷ buscar directorio',                                        'Unite directory'],
    \['▷ buscar directorio reciente',                               'Unite directory_mru'],
    \['▷ buscar directorio con busqueda recursiva',                 'Unite directory_rec/async'],
    \['▷ crear nuevo directorio',                                   'Unite directory/new'],
    \['▷ cambiar directorio de trabajo',                            'Unite -default-action=lcd directory'],
    \['▷ conocer directorio de trabajo',                            'Unite output:pwd'],
    \['▷ archivos desechables                                       ⌘ ,d', 'Unite junkfile/new junkfile'],
    \['▷ guardar como root                                          ⌘ :w!!', 'exe "write !sudo tee % >/dev/null"'],
    \['▷ guardado rapido                                            ⌘ ,w', 'normal ,w'],
    \['▷ abrir ranger                                               ⌘ ,x', 'call RangerChooser()'],
    \['▷ abrir vimfiler                                             ⌘ ,X', 'VimFiler'],
    \]

nnoremap <silent>[menu]o :Unite -silent -winheight=17 -start-insert menu:archivos<CR>

nnoremap <silent><Leader>m :Unite -silent file_mru<CR>
" }}} --archivos
" menu esquemas de color {{{


let g:unite_source_menu_menus.vim = {
    \ 'description' : '            vim
        \                                          ⌘ [espacio]v',
    \}
let g:unite_source_menu_menus.vim.command_candidates = [
    \['▷ escoger esquema de color',
        \'Unite colorscheme -auto-preview'],
    \['▷ atajos de teclado',
        \'Unite mapping -start-insert'],
   \['▷ editar archivo de configuracion (vimrc)',
        \'edit $MYVIMRC'],
    \['▷ establecer el tipo de archivo',
        \'Unite -start-insert filetype'],
    \['▷ ayuda de vim',
        \'Unite -start-insert help'],
    \['▷ comandos de vim',
        \'Unite -start-insert command'],
    \['▷ funciones de vim',
        \'Unite -start-insert function'],
    \['▷ runtimepath de vim',
        \'Unite -start-insert runtimepath'],
    \['▷ salida de comando de vim',
        \'Unite output'],
    \['▷ fuentes de unite',
        \'Unite source'],
    \['▷ matar procesos',
        \'Unite -default-action=sigkill -start-insert process'],
    \['▷ lanzar ejecutable (dmenu like)',
        \'Unite -start-insert launcher'],
    \['▷ limpiar cache de Powerline',
        \'PowerlineClearCache'],
    \]
nnoremap <silent>[menu]v :Unite menu:vim -silent -start-insert<CR>
" }}} -- menu esquemas de color


" Menu ejemplo {{{
let g:unite_source_menu_menus.test = {
            \     'description' : 'Test menu',
            \ }
let g:unite_source_menu_menus.test.candidates = {
            \   'ghci'      : 'VimShellInteractive ghci',
            \ }
function g:unite_source_menu_menus.test.map(key, value)
    return {
                \       'word' : a:key, 'kind' : 'command',
                \       'action__command' : a:value,
                \     }
endfunction
" }}} --- menu ememplo

" set background=dark            " Establece el fondo oscuro.
set t_Co=256                   " Habilita 256 colores en modo consola.
set t_ut=
if has('gui_running')          " Habilita el tema molokai para gvim y vim.
    colorscheme molokai
else
    colorscheme molokai256
endif
" No quiero division entre splits
"set fillchars+=vert:│
set fillchars+=vert:\ 

" Por defecto, busca fuzzy
call unite#filters#matcher_default#use(['matcher_fuzzy'])

" }}} ---Unite

" CtlrP
nmap <leader>b :CtrlPBuffer<cr>

" VimFiler
let g:vimfiler_tree_leaf_icon = ' '
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_file_icon = '-'
let g:vimfiler_readonly_file_icon = '✗'
let g:vimfiler_marked_file_icon = '✓'

let g:vimfiler_enabled_auto_cd = 1
call vimfiler#custom#profile('default','context', { 
            \ 'safe' : 0,
            \'auto_cd': 1})
autocmd FileType vimfiler call s:vimfiler_my_settings()


" Abre shell en la carpeta seleccionada en VimFiller
function! s:vimfiler_michi_shell_in_dir() "{{{

    let vimfile=vimfiler#get_file() 
    if vimfile.vimfiler__is_directory == 1
        let newdir=vimfiler#get_filename()
    else
        let newdir=fnamemodify(vimfile.action__path,':h')
    end
    lcd `=newdir`
    exe ':shell'
endfunction

function! s:vimfiler_my_settings() "{{{
    call vimfiler#set_execute_file('vim', ['vim', 'notepad'])
    call vimfiler#set_execute_file('txt', 'vim')

    " Overwrite settings.
    nnoremap <silent><buffer> - /
    " Call sendto.
    " nnoremap <buffer> - <C-u>:Unite sendto<CR>
    " setlocal cursorline

    nmap <buffer> O <Plug>(vimfiler_sync_with_another_vimfiler)
    nnoremap <silent><buffer><expr> gy vimfiler#do_action('tabopen')
    nmap <buffer> p <Plug>(vimfiler_quick_look)
    nmap <buffer> <LeftRelease> <Plug>(vimfiler_smart_l)
    "nmap <buffer> H :call <SID>vimfiler_michi_shell_in_dir()<cr>

    nunmap <buffer> <c-l>

    " Migemo search.
    if !empty(unite#get_filters('matcher_migemo'))
        nnoremap <silent><buffer><expr> /  line('$') > 10000 ?  'g/' :
                    \ ":\<C-u>Unite -buffer-name=search -start-insert line_migemo\<CR>"
    endif
endfunction"}}}
    
" Change current directory.
nnoremap aaa :<C-u>call <SID>cd_buffer_dir()<CR>
function! s:cd_buffer_dir() "{{{
    let filetype = getbufvar(bufnr('%'), '&filetype')
    if filetype ==# 'vimfiler'
        let dir = getbufvar(bufnr('%'), 'vimfiler').current_dir
    elseif filetype ==# 'vimshell'
        let dir = getbufvar(bufnr('%'), 'vimshell').save_dir
    else
        let dir = isdirectory(bufname('%')) ? bufname('%') : fnamemodify(bufname('%'), ':p:h')
    endif

    cd `=dir`
endfunction"}}}

nnoremap <leader>e :<C-U>VimFilerExplorer -buffer-name=explorer<CR>
autocmd filetype explorer :nnoremap <buffer>- /
nnoremap - /

" vimwiki
let g:vimwiki_list = [{'path': '~/Dropbox/Aplicaciones/Minutes/', 'syntax':'markdown','ext':'.txt'}]
nmap <leader>w- <Plug>VimwikiRemoveHeaderLevel

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


" }}}

" Airline ---------------------------{{{

set laststatus=2
"if !exists('g:airline_symbols')
"let g:airline_symbols = {}
"endif
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_min_count = 2

let g:airline#extensions#tabline#left_sep = ' '
"let g:airline_theme='serene'
let g:airline_theme='zenburn'
" ---------------------------------------------------------}}}


" Configuracion para php -------------------------{{{


" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" tagbar {{{
" Abre la ventana de tag y vuelve al codigo (para poder volver con c-o
"nmap <cr> :tag <c-r><c-w><cr>:TagbarOpen<cr><c-h>
nmap <cr> :tag <c-r><c-w><cr>:TagbarOpen<cr>
let g:tagbar_autoclose=1

" Ultisnips {{{
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsListSnippets="<leader>s"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

nmap <F5> :w<cr>:silent !xvkbd -window Firefox -text '\Cr\A\t'<cr>:redraw!<cr>
