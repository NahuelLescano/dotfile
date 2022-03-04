" Set things
:set number
:set relativenumber
:set autoindent
:set mouse=a

" Plugins
call plug#begin()

Plug 'https://github.com/vim-airline/vim-airline' 	" Status bar
Plug 'https://github.com/ap/vim-css-color' 		" CSS Color Preview 
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " Retro Scheme
Plug 'https://github.com/tc50cal/vim-terminal' 		" Vim Terminal
Plug 'https://github.com/preservim/tagbar' 		" Tagbar for code navigation
Plug 'vimwiki/vimwiki' 					" Vim wiki
Plug 'vifm/vifm.vim'                         		" Vifm

set encoding=UTF-8

call plug#end()

:colorscheme jellybeans
