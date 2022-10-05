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

-- Buffer usage
map('n', '<leader>bn', '<CMD>bn<CR>')           -- Go to next(th) buffer.
map('n', '<leader>bp', '<CMD>bp<CR>')           -- Go to previous(th) buffer.

-- Vifm
map('n', '<leader>vv', '<CMD>Vifm<CR>')         --Open vifm in a new buffer.
map('n', '<leader>vs', '<CMD>VsplitVifm<CR>')   --Open vifm in vertical split.
map('n', '<leader>sp', '<CMD>SplitVifm<CR>')    --Open vifm in horizonal split.
map('n', '<leader>tv', '<CMD>TabVifm>CR>')      --Open vifm in a tab.

-- Vertical split
map('n', '<leader>v', '<CMD>vs<CR>')

-- Horizonal split
map('n', '<leader>h', '<CMD>split<CR>')

-- Open alacritty
map('n', '<leader>t', '<CMD>term<CR>')

-- Load recent sessions
map('n', '<leader>sl', '<CMD>SessionLoad<CR>')

-- Keybindings for telescope
map('n', '<leader>fr', '<CMD>Telescope oldfiles<CR>')
map('n', '<leader>ff', '<CMD>Telescope find_files<CR>')
map('n', '<leader>fb', '<CMD>Telescope file_browser<CR>')
map('n', '<leader>fw', '<CMD>Telescope live_grep<CR>')
map('n', '<leader>ht', '<CMD>Telescope colorscheme<CR>')

-- Back to dashboard
map('n', '<leader>d', '<CMD>Dashboard<CR>')

require('lualine').setup()

-- Dashboard
local db = require('dashboard')
local home = os.getenv('HOME')

db.default_banner = {
  '',
  '',
  ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
  ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
  ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
  ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
  ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
  ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
  '',
  ' [ TIP: To exit Neovim, just power off your computer. ] ',
  '',
}
db.preview_file_height = 11
db.preview_file_width = 70
db.custom_center = {
    {icon = '  ',
    desc = 'Recent sessions                         ',
    shortcut = 'SPC s l',
    action ='SessionLoad'},
    {icon = '  ',
    desc = 'Find recent files                       ',
    action = 'Telescope oldfiles',
    shortcut = 'SPC f r'},
    {icon = '  ',
    desc = 'Find files                              ',
    action = 'Telescope find_files find_command=rg,--hidden,--files',
    shortcut = 'SPC f f'},
    {icon = '  ',
    desc ='File browser                            ',
    action =  'Telescope file_browser',
    shortcut = 'SPC f b'},
    {icon = '  ',
    desc = 'Find word                               ',
    action = 'Telescope live_grep',
    shortcut = 'SPC f w'},
    {icon = '  ',
    desc = 'Load new theme                          ',
    action = 'Telescope colorscheme',
    shortcut = 'SPC h t'},
  }
db.custom_footer = { '', '🎉 If I\'m using Neovim, then my Emacs config must be broken!' }
db.session_directory = "/home/nahuel/.config/nvim/session"

-- COLORSCHEMES
local ok, _ = pcall(vim.cmd, 'colorscheme base16-onedark')

-- PLUGINS
return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- A better status bar
    use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- Telescope and related stuff
    use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
    }

    use { "nvim-telescope/telescope-file-browser.nvim",
        config = function()
        require("telescope").setup {
          extensions = {
            file_browser = {
              theme = "ivy",
              -- disables netrw and use telescope-file-browser in its place
              hijack_netrw = true,
              mappings = {
                ["i"] = {
                  -- your custom insert mode mappings
                },
                ["n"] = {
                  -- your custom normal mode mappings
                },
              },
            },
          },
        }
        end
    }
    -- To get telescope-file-browser loaded and working with telescope,
    -- you need to call load_extension, somewhere after setup function:
    require("telescope").load_extension "file_browser"

    -- Which key
    use {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup { }
      end
    }

    -- Dashboard is a nice start screen for nvim
    use 'glepnir/dashboard-nvim'

    -- File management
    use 'vifm/vifm.vim'
    use 'ryanoasis/vim-devicons'

    -- Productivity --
    use 'vimwiki/vimwiki'
    use 'jreybert/vimagit'

    -- Syntax highlighting and color
    use 'kovetskiy/sxhkd-vim'
    use 'vim-python/python-syntax'

    -- Junegunn Choi Plugins --
    use 'junegunn/goyo.vim'
    use 'junegunn/limelight.vim'
    use 'junegunn/vim-emoji'

    -- Colorschemes
    use 'RRethy/nvim-base16'
    use 'kyazdani42/nvim-palenight.lua'

    -- Other stuff
    use 'frazrepo/vim-rainbow'

end)
