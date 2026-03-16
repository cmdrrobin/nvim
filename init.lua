--
--  ██████   █████                                ███
-- ░░██████ ░░███                                ░░░
--  ░███░███ ░███   ██████   ██████  █████ █████ ████  █████████████
--  ░███░░███░███  ███░░███ ███░░███░░███ ░░███ ░░███ ░░███░░███░░███
--  ░███ ░░██████ ░███████ ░███ ░███ ░███  ░███  ░███  ░███ ░███ ░███
--  ░███  ░░█████ ░███░░░  ░███ ░███ ░░███ ███   ░███  ░███ ░███ ░███
--  █████  ░░█████░░██████ ░░██████   ░░█████    █████ █████░███ █████
-- ░░░░░    ░░░░░  ░░░░░░   ░░░░░░     ░░░░░    ░░░░░ ░░░░░ ░░░ ░░░░░
--
-- This is my personal Neovim setup. You are free to use it, but do not ask for
-- support or requests. This is customized for my needs.

-- [[ Core configurations ]]
require('options')
require('keymaps')
require('autocommands')
require('commands')
require('icons')

-- [[ Plugins ]]
require('plugins.colorscheme')
require('plugins.treesitter')
require('plugins.treesitter-context')
require('plugins.snacks')
require('plugins.oil')

--[[ LSP ]]
require('lsp')
require('plugins.mason')
require('plugins.mason-lspconfig')
require('plugins.blink')
require('plugins.conform')
require('plugins.lint')

--[[ Other ]]
require('plugins.lualine')
require('plugins.vim-sleuth')
require('plugins.nvim-autopairs')
require('plugins.mini-align')
require('plugins.nvim-surround')
require('plugins.todo-comments')
require('plugins.cloak')
require('plugins.ts-comments')
require('plugins.undotree')
require('plugins.mini-icons')
require('plugins.fugitive')
require('plugins.gitsigns')
require('plugins.trouble')
require('plugins.nvim-tmux-navigation')

-- vim: sw=2 ts=2 et
