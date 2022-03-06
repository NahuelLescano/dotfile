" General settings
set autoindent
set mouse=a
set encoding=UTF-8

" Plugins
call plug#begin()

Plug 'https://github.com/vim-airline/vim-airline' 	" Status bar
Plug 'vimwiki/vimwiki' 					" Vim wiki
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " Retro Scheme

call plug#end() 

" Key bindings
nnoremap <Up>    :resize -2<CR>
nnoremap <Down>  :resize +2<CR>
nnoremap <Left>  :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

