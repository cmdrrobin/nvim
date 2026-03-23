-- A pretty list for showing diagnostics, references, telescope results,
-- quickfix and location lists to help you solve all the trouble your code
-- is causing.
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    vim.pack.add({ 'https://github.com/folke/trouble.nvim' })
    require('trouble').setup()

    vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Document Diagnostics (Trouble)' })
    vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Workspace Diagnostics (Trouble)' })
    vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle<cr>', { desc = 'Symbols (Trouble)' })
    vim.keymap.set('n', '<leader>cS', '<cmd>Trouble lsp toggle<cr>', { desc = 'LSP references/definitions/... (Trouble)' })
    vim.keymap.set('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location List (Trouble)' })
    vim.keymap.set('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix List (Trouble)' })
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
