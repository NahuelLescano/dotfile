-- References
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
map('n', '<leader>vv', '<CMD>Vifm<CR>')
map('n', '<leader>vs', '<CMD>VsplitVifm<CR>')
map('n', '<leader>sp', '<CMD>SplitVifm<CR>')
map('n', '<leader>dv', '<CMD>DiffVifm<CR>')
map('n', '<leader>tv', '<CMD>TabVifm>CR>')

-- Vertical split
map('n', 'vs', '<CMD>vs<CR>')

require('lualine').setup()

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require'lspconfig'.pyright.setup{
    capabilities = capabilities,
    on_attach = function() 
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = 0 })
        vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, { buffer = 0 })
        vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, { buffer = 0 })
    end,
}

opt.completeopt={ "menu" ,"menuone" ,"noselect" }

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
       require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

  --Debugging
vim.keymap.set("n","<F5>", "<CMD>lua require'dap'.continue()<CR>")
vim.keymap.set("n","<F10>", "<CMD>lua require'dap'.step_over()<CR>")
vim.keymap.set("n","<F11>", "<CMD>lua require'dap'.step_into()<CR>")
vim.keymap.set("n","<F12>", "<CMD>lua require'dap'.step_out()<CR>")
vim.keymap.set("n","<leader>b", "<CMD>lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n","<leader>B", "<CMD>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n","<leader>lp", "<CMD>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")

require("dapui").setup()

-- COLORSCHEMES
local ok, _ = pcall(vim.cmd, 'colorscheme base16-ayu-dark')

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
    use 'ryanoasis/vim-devicons'

    -- Productivity --
    use 'vimwiki/vimwiki'
    use 'jreybert/vimagit'

    -- Syntax highlighting and color
    use 'kovetskiy/sxhkd-vim'
    use 'vim-python/python-syntax'

    -- Configurations for nvim LSP
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/nvim-cmp'
    
    -- For vsnip users.
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    
    -- For luasnip users.
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    
    -- For ultisnips users.
    use 'SirVer/ultisnips'
    use 'quangnguyen30192/cmp-nvim-ultisnips'
    
    -- For snippy users.
    use 'dcampos/nvim-snippy'
    use 'dcampos/cmp-snippy'

    --Debugging
    use 'mfussenegger/nvim-dap'
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

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
