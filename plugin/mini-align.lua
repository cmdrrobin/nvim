-- Align text interactively
vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.align', version = vim.version.range('*') },
})

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    require('mini.align').setup()
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
