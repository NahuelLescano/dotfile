" Plugins
call plug#begin()

" Basic plugs
Plug 'https://github.com/vim-airline/vim-airline' 	    " Status bar
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " Retro Scheme
Plug 'itchyny/lightline.vim'                       	    " Lightline statusbar
Plug 'suan/vim-instant-markdown', {'rtp': 'after'} 	    " Markdown Preview
Plug 'frazrepo/vim-rainbow'

" File manager in vim
Plug 'vifm/vifm.vim'                               	    " Vifm
Plug 'scrooloose/nerdtree'                          	" Nerdtree
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'     	    " Highlighting Nerdtree
Plug 'ryanoasis/vim-devicons'                      	    " Icons for Nerdtree

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

set encoding=UTF-8
set autoindent
set number                  " Display line numbers
set path+=**			    " Searches current directory recursively.
set wildmenu			    " Display all matches when tab complete.
set incsearch               " Incremental search
set hidden                  " Needed to keep multiple buffers open
set t_Co=256                " Set if term supports 256 colors.
set clipboard=unnamedplus   " Copy/paste between vim and other programs.

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

" Nerdtree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '►'
let g:NERDTreeDirArrowCollapsible = '▼'
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeMinimalUI = 1
let g:NERDTreeWinSize=38

" Color and theme
highlight Normal           guifg=#dfdfdf ctermfg=15   guibg=#282c34 ctermbg=none  cterm=none
highlight LineNr           guifg=#5b6268 ctermfg=8    guibg=#282c34 ctermbg=none  cterm=none
highlight CursorLineNr     guifg=#202328 ctermfg=7    guifg=#5b6268 ctermbg=8     cterm=none
highlight VertSplit        guifg=#1c1f24 ctermfg=0    guifg=#5b6268 ctermbg=8     cterm=none
highlight Statement        guifg=#98be65 ctermfg=2    guibg=none    ctermbg=none  cterm=none
highlight Directory        guifg=#51afef ctermfg=4    guibg=none    ctermbg=none  cterm=none
highlight StatusLine       guifg=#202328 ctermfg=7    guifg=#5b6268 ctermbg=8     cterm=none
highlight StatusLineNC     guifg=#202328 ctermfg=7    guifg=#5b6268 ctermbg=8     cterm=none
highlight NERDTreeClosable guifg=#98be65 ctermfg=2
highlight NERDTreeOpenable guifg=#5b6268 ctermfg=8
highlight Comment          guifg=#51afef ctermfg=4    guibg=none    ctermbg=none  cterm=italic
highlight Constant         guifg=#3071db ctermfg=12   guibg=none    ctermbg=none  cterm=none
highlight Special          guifg=#51afef ctermfg=4    guibg=none    ctermbg=none  cterm=none
highlight Identifier       guifg=#5699af ctermfg=6    guibg=none    ctermbg=none  cterm=none
highlight PreProc          guifg=#c678dd ctermfg=5    guibg=none    ctermbg=none  cterm=none
highlight String           guifg=#3071db ctermfg=12   guibg=none    ctermbg=none  cterm=none
highlight Number           guifg=#ff6c6b ctermfg=1    guibg=none    ctermbg=none  cterm=none
highlight Function         guifg=#ff6c6b ctermfg=1    guibg=none    ctermbg=none  cterm=none
highlight Visual           guifg=#dfdfdf ctermfg=1    guibg=#1c1f24 ctermbg=none  cterm=none

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
