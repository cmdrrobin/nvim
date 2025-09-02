---@module 'lazy'
---@type LazySpec
return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ['<C-p>'] = false,
        ['gp'] = 'actions.preview',
      },
    },
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    keys = {
      { '<leader>e', '<cmd>Oil<CR>', desc = 'Open File Explorer' },
    },
  },
  {
    'benomahony/oil-git.nvim',
    dependencies = { 'stevearc/oil.nvim' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
