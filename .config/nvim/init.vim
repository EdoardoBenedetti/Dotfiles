" GENERAL SETTINGS
set title							" Filename
set number						" Line Number
set mouse=a						" Enable Mouse

set nowrap						" Do not break long lines

set cursorline				" Highlight Line
set colorcolumn=100		" Column Line

set smartindent				" Smart Indent
set tabstop=2					" Tab Indent
set expandtab
set shiftwidth=2

set spelllang=en			" Spell Check


" KEY BINDINGS
nnoremap <C-s> :w<CR>						" Save with Ctrl+S


" AUTOSTART
" autocmd VimEnter * NERDTree

" PLUGINS
call plug#begin()

Plug 'scrooloose/nerdtree'
Plug 'glepnir/dashboard-nvim'

call plug#end()
