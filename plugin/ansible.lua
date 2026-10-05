vim.pack.add({
  { src = 'https://github.com/mfussenegger/nvim-ansible' },
}, { load = false })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('cmdrrobin-ansible', { clear = true }),
  pattern = 'ansible',
  callback = function()
    vim.cmd.packadd('nvim-ansible')
  end,
})
