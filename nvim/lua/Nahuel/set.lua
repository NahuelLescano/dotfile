-- General settings
vim.g.maplocalleader = " "
vim.g.mapleader = " "

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

-- Deactivating swap and backup files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Makes neovim and host OS clipboard play nicely with each other
vim.opt.clipboard = "unnamedplus"

vim.opt.updatetime = 50

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Better buffer splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Better editing experience
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.cindent = true
vim.opt.autoindent = true
vim.opt.wrap = true
vim.opt.textwidth = 300
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = -1 -- If negative, shiftwidth value is used
vim.opt.list = true

-- Remember 50 items in commandline history
vim.opt.history = 50

-- Highlight the region on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 120 })
    end,
})

-- Buffer usage
vim.keymap.set('n', '<leader>bn', '<CMD>bn<CR>')           -- Go to next(th) buffer.
vim.keymap.set('n', '<leader>bp', '<CMD>bp<CR>')           -- Go to previous(th) buffer.

-- Vertical split
vim.keymap.set('n', '<leader>v', '<CMD>vs<CR>')

-- Horizonal split
vim.keymap.set('n', '<leader>h', '<CMD>split<CR>')

-- Open alacritty
vim.keymap.set('n', '<leader>t', '<CMD>term<CR>')


