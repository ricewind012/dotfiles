" Colors
colorscheme xresources

au BufNewFile,BufRead /*.rasi setf scss
au BufNewFile,BufRead /*.styl setf scss
au BufNewFile,BufRead /*zsh.d* setf zsh
au BufNewFile,BufRead /usr/share/zsh/* setf zsh

" Visual
set ruler
set number
set colorcolumn=65
set linebreak
set cursorline
set incsearch
set hlsearch
set showcmd
set title
set display=truncate
set statusline=%=%t\ --\ %l/%L
let &titlestring = "vim" . $delim . "%t"

" Mouse
set mouse=a
set guicursor=

" Tabs
set tabstop=2
set shiftwidth=2
set noexpandtab
set smartindent

" etc.
set nocompatible " No vi compatibility
set backspace=indent,eol,start
set history=5000
set clipboard=unnamedplus
let c_comment_strings=1

" Jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if has('persistent_undo')
	" keep an undo file (undo changes after closing)
	set undofile
endif
set nobackup

" Keybindings
nnoremap q: :q<CR>
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
nnoremap <F6> :w\|n<CR>
nnoremap <F2> :x<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>
inoremap <F6> <Esc>:w\|n<CR>
inoremap <F2> <Esc>:x<CR>

map <C-A> <Esc>ggVG
map <C-C> <Esc>y
map <C-V> <Esc>o<Esc>p<Esc>A<Esc>
