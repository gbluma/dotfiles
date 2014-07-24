
set nocompatible              " be iMproved
filetype off                  " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" let Vundle manage Vundle " required! 
Bundle 'gmarik/vundle'

" standard plugins
Bundle 'surround.vim'
Bundle 'junegunn/vim-easy-align'
Bundle "mattn/emmet-vim"

" controlling Git
Bundle 'tpope/vim-fugitive'

" file searching
Bundle 'kien/ctrlp.vim'

" Clojure editing
Bundle 'tpope/vim-fireplace'
Bundle 'tpope/vim-classpath'
Bundle 'guns/vim-clojure-static'

" Scala
Bundle 'derekwyatt/vim-scala'

" Idris editing
Bundle 'idris-hackers/idris-vim'

" Nerdtree
Bundle 'scrooloose/nerdtree'

" Elixir
Bundle 'elixir-lang/vim-elixir'

" Rust
Bundle "wting/rust.vim"

" PHP
Bundle "beberlei/vim-php-refactor"	

" HAXE
Bundle "jdonaldson/vaxe"

filetype plugin indent on     " required!

" ------------------------------

colo grb256
set background=dark

"set background=light
"set t_Co=16
"colo grb4

set nobackup
set wrap
set number           "line numbers
set hidden

"Indentation Settings
set autoindent
set autowrite
set expandtab
set smartindent
set sw=2
set tabstop=4
set shiftwidth=4
set softtabstop=4

"Textmate style invisible characters
"set listchars=tab:›\ ,eol:¬
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set nolist

let mapleader = ","
set history=7000

"faster scrolling
nnoremap <C-e> 8<C-e>
nnoremap <C-y> 8<C-y>

" remap naviagation keys to work in textwrapped text
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$

"Manage Tabs Easier
nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabprev<CR>

"auto sudo for admin rights (use :w!! to save)
cmap w!! %!sudo tee > /dev/null %
command! W :w

"make shortcuts
:map ,b :w\|:!make build<cr>
:map ,r :w\|:!make run<cr>
:map <leader>t :w\|:!make test<cr>

:map ,, <C-^>

"Allow for actually good silent commands
command! -nargs=1 Silent
\ | execute ':silent !'.<q-args>
\ | execute ':redraw!'

"Always show filename at bottom
:set ls=2
:set ruler
:set showtabline=2

map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

" Rename current file
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

" special autocompletion
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col -1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" NerdTree
nnoremap <Space> :NERDTreeToggle<cr>
let NERDTreeIgnore=['\.hi$','\.o$','\.pyc$','\.class$','\.png$','\.jpg$','\.gif$']

map ,1 :!pred<cr>
map ,2 :!unpred<cr>

" command to pull up the previous version of said line
map ,h :r !git diff \| grep <cword> \| grep -<cr>

func! GetSelectedText()
    normal gv"xy
    let result = getreg("x")
    normal gv
    return result
endfunc

function! ExtractVariable()
    let name = input("Variable name: ")
    if name == ''
        return
    endif
    " Enter visual mode (not sure why this is needed since we're already in
    " visual mode anyway)
    normal! gv

    " Replace selected text with the variable name
    exec "normal d" . name
    " Define the variable on the line above
    exec "normal! O$" . name . " = "
    " Paste the original selected text to be the variable value
    normal! $p
    exec "normal! A;"
endfunction
vnoremap <leader>p :call ExtractVariable()<cr>

vmap <leader>e :call ExtractMethod()<CR>
function! ExtractMethod() range
  let name = inputdialog("Name of new method:")
  '<
  exe "normal! O\<BS>public " . name ."()\<CR>{\<Esc>"
  '>
  exe "normal! oreturn ;\<CR>}\<Esc>k"
  normal! j%
  normal! kf(
  "exe "normal! yyPi \<Esc>wdwA;\<Esc>"
  normal! ==
  normal! j0w
endfunction

if has("gui_running")
  "hide toolbar
  set guioptions=egmrt
  " GUI customizations
  set background=light
  colo autumnleaf
  set gfn=Monospace\ 11
endif
