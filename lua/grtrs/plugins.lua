-- Automatically install packer
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end

vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            vim.cmd.colorscheme "catppuccin-macchiato"
        end
    },

    -- Make bufferlines pretty
    {
        "akinsho/bufferline.nvim",
        lazy = true,
        dependencies = "kyazdani42/nvim-web-devicons",
    },
    -- Blazing fast statusline
    { "nvim-lualine/lualine.nvim",
        lazy = true,
        dependencies = "kyazdani42/nvim-web-devicons",
    },

    -- Make comments pretty
    {
        "numToStr/Comment.nvim",
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
        config = function()
            require("Comment").setup({
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            })
        end
    },
    -- Undotree
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
        },
    },

    -- Close buffers by keeping layout
    "moll/vim-bbye",
    -- Aligning lines
    "Vonr/align.nvim",
    -- Autopair
    "windwp/nvim-autopairs",
    -- Indentation guides
    { "lukas-reineke/indent-blankline.nvim", lazy = true },

    -- highlight todo comments
    { "folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim", lazy = true },
    -- Surround selections
    { "kylechui/nvim-surround", lazy = true },

    -- Show colour codes
    { "NvChad/nvim-colorizer.lua", lazy = true },

    -- LSP
    {
        'VonHeikemen/lsp-zero.nvim',
        lazy = true,
        dependencies = {
            -- LSP Support
            'neovim/nvim-lspconfig',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Autocompletion
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',

            -- Snippets
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
        },
    },
    -- for formatters and linters
    { "jose-elias-alvarez/null-ls.nvim", lazy = true },
    -- Highlight words
    { "RRethy/vim-illuminate", lazy = true },
    -- VSCode icons
    { "onsails/lspkind-nvim", lazy = true },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-context" -- Show context
        },
        build = ":TSUpdate"
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Fuzzy Finder Algorithm
        },
        lazy = true,
    },
    -- Project window
    { "ahmedkhalf/project.nvim", lazy = true },

    -- Buffer management
    { "ThePrimeagen/harpoon", lazy = true },

    -- Git
    -- Fugitive, from the godfather of Vim
    {
        "tpope/vim-fugitive"
    },
    -- Superfast Git decorations
    "lewis6991/gitsigns.nvim",
    -- Git Blame
    {
        "f-person/git-blame.nvim",
        keys = {
            { "<leader>gb", "<cmd>GitBlameToggle<CR>", desc = "[G]it [B]lame toggle" },
        },
        init = function()
            vim.g.gitblame_enabled = 0
            vim.g.gitblame_message_template = "<sha> • <summary> • <date> • <author>"
            require("gitblame")
        end
    },
    -- Lazygit for Neovim
    {
        "kdheepak/lazygit.nvim",
        keys = {
            { "<leader>lg", "<cmd>LazyGit<CR>", desc = "[L]azy [G]it" },
        },
    },

    -- editorconfig
    { "gpanders/editorconfig.nvim" },

    -- DAP
    { "mfussenegger/nvim-dap", lazy = true },
    { "rcarriga/nvim-dap-ui", lazy = true },
    { "theHamsta/nvim-dap-virtual-text", lazy = true },
    {
        "nvim-telescope/telescope-dap.nvim",
        config = function()
            require('telescope').load_extension('dap')
        end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-nvim-dap").setup({ automatic_setup = true })
        end
    },

    -- Markdown Previewer
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
})
