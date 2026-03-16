vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    vim.pack.add({ 'https://github.com/christoomey/vim-tmux-navigator' })

    vim.keymap.set('n', '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>')
    vim.keymap.set('n', '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>')
    vim.keymap.set('n', '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>')
    vim.keymap.set('n', '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>')
    vim.keymap.set('n', '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>')
  end,
})
-- cmd = {
--   'TmuxNavigateLeft',
--   'TmuxNavigateDown',
--   'TmuxNavigateUp',
--   'TmuxNavigateRight',
--   'TmuxNavigatePrevious',
--   'TmuxNavigatorProcessList',
-- },

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
