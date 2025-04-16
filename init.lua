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

-- [[ Lazy ]]
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- definition for loading extras
local extras = require('extras')

-- [[ Core configurations ]]
require('options')
require('keymaps')
require('autocommands')
require('commands')
require('lsp')

-- [[ Lazy plugins ]]
require('lazy').setup({
  spec = {
    { import = 'plugins' },
    unpack(extras.get_enabled_extras_spec()),
  },
  change_detection = { notify = false }, -- disable changes notifications
  install = {
    colorscheme = { 'rose-pine' },
  },
})

-- vim: sw=2 ts=2 et
