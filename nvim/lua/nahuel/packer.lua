-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

-- lualine startup
require('lualine').setup()
return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

   -- A better status bar
    use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

	-- Telescope
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

    -- Dashboard
    use("glepnir/dashboard-nvim")

	-- Colorschemes
	use 'RRethy/nvim-base16'
	use 'kyazdani42/nvim-palenight.lua'

	-- Treesitter
	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
 	use('nvim-treesitter/playground')

	-- Harpoon
 	use('ThePrimeagen/harpoon')

	-- Undo tree
 	use('mbbill/undotree')

	-- fugitive (git client for nvim)
	use('tpope/vim-fugitive')

    -- LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {                                      -- Optional
            'williamboman/mason.nvim',
            run = function()
                pcall(vim.cmd, 'MasonUpdate')
            end,
        },
        {'williamboman/mason-lspconfig.nvim'}, -- Optional

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},     -- Required
        {'hrsh7th/cmp-nvim-lsp'}, -- Required
        {'L3MON4D3/LuaSnip'},     -- Required
    }
}

    -- Which key
    use {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup { }
      end
    }

    -- Telescope file browsing
    -- -- Telescope file browsing
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

    -- nvim icons
    use('nvim-tree/nvim-web-devicons')

    -- File management
    use('vifm/vifm.vim')
    use('ryanoasis/vim-devicons')

    -- Junegunn Choi Plugins --
    use('junegunn/goyo.vim')
    use('junegunn/limelight.vim')
    use('junegunn/vim-emoji')

    -- Other stuff
    use('frazrepo/vim-rainbow')
end)
