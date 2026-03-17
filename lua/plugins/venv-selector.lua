vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  once = true,
  callback = function()
    vim.pack.add({ 'https://github.com/linux-cultist/venv-selector.nvim' })

    -- Setup the plugin
    require('venv-selector').setup({
      -- Plugin will auto-detect common venv locations
      -- No additional config needed for basic functionality
    })

    -- Keymaps
    vim.keymap.set('n', '<leader>vs', '<cmd>VenvSelect<cr>', { desc = '[V]env [S]elect' })
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
