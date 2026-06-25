local add = require('vim-pack').add

add({
  { src = 'https://github.com/benomahony/oil-git.nvim' },
  {
    src = 'https://github.com/stevearc/oil.nvim',
    opts = {
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ['<C-p>'] = false,
        ['gp'] = 'actions.preview',
      },
    },
    on_setup = function()
      vim.keymap.set('n', '<leader>e', vim.cmd.Oil, { desc = 'Oil' })
    end,
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
