-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Lualine
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        -- or                            , branch = '0.1.x', requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- Colorschemes
    use 'RRethy/nvim-base16'
    use 'kyazdani42/nvim-palenight.lua'
    use { "catppuccin/nvim", as = "catppuccin" }

    -- Treesitter
    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use('nvim-treesitter/playground')

    -- Harpoon
    use('nvim-lua/plenary.nvim')  -- don't forget to add this one if you don't have it yet!
    use('ThePrimeagen/harpoon')

    -- Undotree
    use('mbbill/undotree')

    -- Git client (like magit)
    use('tpope/vim-fugitive')

    -- Beacon
    use('danilamihailov/beacon.nvim')

    -- LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {'williamboman/mason.nvim'},           -- Optional
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    }

    -- telescope file browser
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

    -- Which key
    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    -- vimwiki
    use('vimwiki/vimwiki')

    -- Org mode
    use {'nvim-orgmode/orgmode', config = function()
        require('orgmode').setup{}
    end
}

    -- File management stuff
    use('vifm/vifm.vim')
    use('ryanoasis/vim-devicons')
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
    }
    -- Junegunn Choi Plugins --
    use('junegunn/goyo.vim')
    use('junegunn/limelight.vim')
    use('junegunn/vim-emoji')

    -- Other stuff
    use('frazrepo/vim-rainbow')

    -- tmux integration with nvim
    use('christoomey/vim-tmux-navigator')
end)
