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
require('statusline')

-- [[ Plugins ]]
require('plugins.colorscheme')
require('plugins.treesitter')
require('plugins.snacks')
require('plugins.oil')

--[[ LSP ]]
require('lsp')
require('plugins.nvim-lspconfig')
require('plugins.mason')

--[[ Coding ]]
require('plugins.blink')
require('plugins.conform')
require('plugins.lint')
require('plugins.schemastore')
require('plugins.venv-selector')

--[[ Other ]]
require('plugins.vim-sleuth')
require('plugins.vim-surround')
require('plugins.fugitive')
require('plugins.gitsigns')
require('plugins.nvim-autopairs')
require('plugins.mini-align')
require('plugins.mini-icons')
require('plugins.todo-comments')
require('plugins.ts-comments')
require('plugins.undotree')
require('plugins.trouble')
require('plugins.cloak')
require('plugins.nvim-tmux-navigation')
require('plugins.markdownpreview')

-- vim: sw=2 ts=2 et
