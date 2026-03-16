-- Is all about "surroundings": parentheses, brackets, quotes, XML tags, and more
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    vim.pack.add({
      { src = 'https://github.com/kylechui/nvim-surround', version = vim.version.range('*') },
    })
    require('nvim-surround').setup()
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
