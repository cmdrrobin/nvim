-- Start build process when installing or updating markdown-preview.nvim plugin
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    -- Run build script after plugin's code has changed
    if name == 'markdown-preview.nvim' and (kind == 'install' or kind == 'update') then
      vim.system({ 'cd app && npm install' }, { cwd = ev.data.path })
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('cmdrrobin-markdown-detect', { clear = true }),
  pattern = 'markdown',
  callback = function()
    vim.pack.add({ 'https://github.com/iamcco/markdown-preview.nvim' })
    vim.g.mkdp_filetypes = { 'markdown' }

    vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<CR>', { silent = true, desc = '[M]arkdown [P]review' })
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
