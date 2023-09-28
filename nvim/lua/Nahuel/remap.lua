-- Most of the stuff is from The Primeagen
vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>dj", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader><leader>", "<cmd>so<CR>")

-- Tmux
vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>")
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>")

-- Telescope file browser
vim.keymap.set("n", "<leader>hrr", "<cmd>PackerSync<CR>")
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>")
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fb", "<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>")
vim.keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>ht", "<cmd>Telescope colorscheme<CR>")

-- nvim tree
vim.keymap.set("n", "<leader>n", "<cmd>NvimTreeOpen<CR>")
vim.keymap.set("n", "<leader>c", "<cmd>NvimTreeClose<CR>")
vim.keymap.set("n", "<leader>r", "<cmd>NvimTreeRefresh<CR>")

-- Netrw stuff
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 25
-- vim.g.netrw_liststyle = 3
