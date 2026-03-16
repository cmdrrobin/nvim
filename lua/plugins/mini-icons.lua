vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    vim.pack.add({ 'https://github.com/nvim-mini/mini.icons' })
    require('mini.icons').setup()
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
