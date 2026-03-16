vim.pack.add({
  'https://github.com/mason-org/mason.nvim',
})

local opts = {
  ensure_installed = {
    'stylua',
    'shfmt',
  },
}

require('mason').setup(opts)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
