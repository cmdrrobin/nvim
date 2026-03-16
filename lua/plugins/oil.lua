vim.pack.add({
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/benomahony/oil-git.nvim',
})
---@module 'oil'
---@type oil.SetupOpts
require('oil').setup({
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ['<C-p>'] = false,
    ['gp'] = 'actions.preview',
  },
})
vim.keymap.set('n', '<leader>e', vim.cmd.Oil, { desc = 'Oil' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
