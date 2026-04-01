-- Undotree visualizes the undo history and makes it easy to browse and switch
-- between different undo branches.
-- vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
--   once = true,
--   callback = function()
--     vim.pack.add({ 'https://github.com/mbbill/undotree' })
--     vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<CR>', { desc = 'Toggle Undotree' })
--   end,
-- })
vim.cmd('packadd nvim.undotree')
vim.keymap.set('n', '<leader>u', require('undotree').open)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
