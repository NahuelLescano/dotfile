" Plugins
call plug#begin()

" Basic plugs
Plug 'https://github.com/vim-airline/vim-airline' 	    " Status bar
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " Retro scheme
Plug 'itchyny/lightline.vim'                       	    " Lightline statusbar
Plug 'suan/vim-instant-markdown', {'rtp': 'after'} 	    " Markdown Preview
Plug 'frazrepo/vim-rainbow'

" File manager in vim
Plug 'vifm/vifm.vim'                               	    " Vifm

" Productivity
Plug 'jreybert/vimagit'
Plug 'vimwiki/vimwiki' 					                " Vim wiki

" Sintax highlighting and colors
Plug 'vim-python/python-syntax'                    	    " Python highlighting

" Fun plugs for vim
Plug 'junegunn/goyo.vim'                           	    " Distraction-free viewing
Plug 'junegunn/limelight.vim'                      	    " Hyperfocus on a range
Plug 'junegunn/vim-emoji'                          	    " Vim needs emojis!

call plug#end()

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" General settings
" Mouse scrolling
set mouse=nicr
set mouse=a

set cursorline

set encoding=UTF-8          " Support for encoding
set autoindent
set number
set path+=**			    " Searches current directory recursively.
set wildmenu			    " Display all matches when tab complete.
set incsearch               " Incremental search
set hidden                  " Needed to keep multiple buffers open
set t_Co=256                " Set if term supports 256 colors.
set clipboard=unnamedplus   " Copy/paste between vim and other programs.

colorscheme minimalist      " My colorscheme of choice

" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Key bindings
"nnoremap <Up>    :resize -2<CR>
"nnoremap <Down>  :resize +2<CR>
"nnoremap <Left>  :vertical resize +2<CR>
"nnoremap <Right> :vertical resize -2<CR>

" Always show statusline
set laststatus=2

" Uncomment to prevent non-normal modes showing in powerline and below powerline.
set noshowmode

" Text, tab and indent related
set expandtab                   " Use spaces instead of tabs.
set smarttab                    " Be smart using tabs ;)
set shiftwidth=4                " One tab == four spaces.
set tabstop=4                   " One tab == four spaces.

" Vifm
map <Leader>vv :Vifm<CR>
map <Leader>vs :VsplitVifm<CR>
map <Leader>sp :SplitVifm<CR>
map <Leader>dv :DiffVifm<CR>
map <Leader>tv :TabVifm<CR>

" Vim wiki
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

" Vim instant markdown
"let g:instant_markdown_autostart = 0         " Turns off auto preview
"let g:instant_markdown_browser = "surf"      " Uses surf for preview
"map <Leader>md :InstantMarkdownPreview<CR>   " Previews .md file
"map <Leader>ms :InstantMarkdownStop<CR>      " Kills the preview

" Fix sizing bug with Alacritty terminal
autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"

" Split and tabbed files
set splitbelow splitright

let g:python_highlight_all = 1
