-- autopairs
-- https://github.com/windwp/nvim-autopairs
vim.pack.add({ 'https://github.com/windwp/nvim-autopairs' })

vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    require('nvim-autopairs').setup()
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
