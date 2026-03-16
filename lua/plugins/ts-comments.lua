-- enhanced builtin nvim comments
vim.api.nvim_create_autocmd('BufReadPost', {
  once = true,
  callback = function()
    vim.pack.add({ 'https://github.com/folke/ts-comments.nvim' })
    require('ts-comments').setup()
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
