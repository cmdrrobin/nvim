-- Make it possible to format manually
vim.api.nvim_create_user_command('Format', function()
  local conform_ok, conform = pcall(require, 'conform')
  if conform_ok then
    conform.format({ async = true, lsp_fallback = true })
  else
    vim.lsp.buf.format()
  end
end, { desc = 'Format current buffer', nargs = 0 })

-- Make it possible to toggle auto formatting
vim.api.nvim_create_user_command('ToggleFormat', function()
  vim.g.format_on_save = not vim.g.format_on_save
  vim.notify(string.format('%s formatting...', vim.g.format_on_save and 'Enabling' or 'Disabling'), vim.log.levels.INFO)
end, { desc = 'Toggle conform.nvim auto-formatting', nargs = 0 })

vim.api.nvim_create_user_command('GoToFile', 'lua Snacks.picker.smart()', { desc = 'Open smart file picker', nargs = 0 })
vim.api.nvim_create_user_command('GoToNotes', 'ObsidianSearch', { desc = 'Search Obsidian notes', nargs = 0 })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
