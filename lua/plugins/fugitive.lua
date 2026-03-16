-- Fugitive is the premier Vim plugin for Git. Or maybe it's the premier Git
-- plugin for Vim? Either way, it's "so awesome, it should be illegal". That's
-- why it's called Fugitive.
vim.schedule(function()
  vim.pack.add({ 'https://github.com/tpope/vim-fugitive' })
end)

-- stylua: ignore start
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>gp', function() vim.cmd.Git('push') end, { desc = '[G]it [p]ush' })
vim.keymap.set('n', '<leader>gP', function() vim.cmd.Git('pull --rebase') end, { desc = 'Git [P]ull' })
vim.keymap.set('n', '<leader>gt', ':Git push -u origin ', { desc = '[G]it push with [t]racking' })
-- stylua: ignore end
