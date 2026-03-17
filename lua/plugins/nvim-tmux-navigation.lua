vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    vim.pack.add({ 'https://github.com/christoomey/vim-tmux-navigator' })

    -- Remove existing mappings
    vim.keymap.del('n', '<C-h>')
    vim.keymap.del('n', '<C-j>')
    vim.keymap.del('n', '<C-k>')
    vim.keymap.del('n', '<C-l>')
    -- Add Tmux navigator mappings
    vim.keymap.set('n', '<c-h>', '<cmd>TmuxNavigateLeft<cr>')
    vim.keymap.set('n', '<c-j>', '<cmd>TmuxNavigateDown<cr>')
    vim.keymap.set('n', '<c-k>', '<cmd>TmuxNavigateUp<cr>')
    vim.keymap.set('n', '<c-l>', '<cmd>TmuxNavigateRight<cr>')
    vim.keymap.set('n', '<c-\\>', '<cmd>TmuxNavigatePrevious<cr>')
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
