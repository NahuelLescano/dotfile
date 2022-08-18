-- References:
-- https://github.com/numToStr/dotfiles/tree/master/neovim/.config/nvim/
-- https://www.youtube.com/watch?v=m62UCkdQ8Ck&t=698s

local g   = vim.g
local o   = vim.o
local A   = vim.api
local opt = vim.opt

o.termguicolors = true

-- Decrease update time
o.timeoutlen = 500
o.updatetime = 200

-- Number of screen lines to keep above and below the cursor
o.scrolloff = 8

-- Better editor UI
o.number = true
o.numberwidth = 2
o.relativenumber = true
o.signcolumn = 'yes'
o.cursorline = true

-- Better editing experience
o.expandtab = true
o.smarttab = true
o.cindent = true
o.autoindent = true
o.wrap = true
o.textwidth = 300
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = -1 -- If negative, shiftwidth value is used
o.list = true
o.listchars = 'trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂'

-- Makes neovim and host OS clipboard play nicely with each other
o.clipboard = 'unnamedplus'

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase =  true

-- Undo and backup options
o.backup = false
o.writebackup = false
o.undofile = true
o.undodir = '/home/nahuel/.nvim/undodir'
o.swapfile = false

-- Remember 50 items in commandline mode
o.history = 50

-- Better buffer splitting
o.splitright = true
o.splitbelow = true

opt.mouse = "a"

-- Map <leader> to space (emacs leader keycore)
g.mapleader = ' '
g.maplocalleader = ' '

-- Highlight the region on yank
A.nvim_create_autocmd('TextYankPost', {
    group = num_au,
    callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 120 })
    end,
})

-- KEYBINDINGS
local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true })
end

-- Vifm
map('n', '<leader>vv', ':Vifm<CR>')
map('n', '<leader>vs', ':VsplitVifm<CR>')
map('n', '<leader>sp', ':SplitVifm<CR>')
map('n', '<leader>dv', ':DiffVifm<CR>')
map('n', '<leader>tv', ':TabVifm>CR>')

require('lualine').setup()

require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

-- COLORSCHEMES
-- Uncomment just ONE of the following colorschemes!
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-dracula')
local ok, _ = pcall(vim.cmd, 'colorscheme base16-ayu-dark')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-gruvbox-dark-medium')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-monokai')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-nord')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-oceanicnext')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-onedark')
-- local ok, _ = pcall(vim.cmd, 'colorscheme palenight')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-solarized-dark')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-solarized-light')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-tomorrow-night')

-- Automatically install and set up packer.vim
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

-- PLUGINS
return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- A better status bar
    use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- File management
    use 'vifm/vifm.vim'
    use 'scrooloose/nerdtree'
    use 'tiagofumo/vim-nerdtree-syntax-highlight'
    use 'ryanoasis/vim-devicons'

    -- Productivity --
    use 'vimwiki/vimwiki'
    use 'jreybert/vimagit'

    -- Syntax highlighting and color
    use 'kovetskiy/sxhkd-vim'
    use 'vim-python/python-syntax'

    -- Configurations for nvim LSP
    use 'neovim/nvim-lspconfig'

    -- Junegunn Choi Plugins --
    use 'junegunn/goyo.vim'
    use 'junegunn/limelight.vim'
    use 'junegunn/vim-emoji'

    -- Colorschemes
    use 'RRethy/nvim-base16'
    use 'kyazdani42/nvim-palenight.lua'

    -- Other stuff
    use 'frazrepo/vim-rainbow'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
