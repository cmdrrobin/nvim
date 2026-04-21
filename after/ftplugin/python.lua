-- Setup the plugin
require('venv-selector').setup({
  -- Plugin will auto-detect common venv locations
  -- No additional config needed for basic functionality
})

-- Keymaps
vim.keymap.set('n', '<leader>vs', '<cmd>VenvSelect<cr>', { desc = '[V]env [S]elect' })
