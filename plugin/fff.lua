-- Package name changed from `fff.nvim` to `fff`. If you installed fff.nvim before, clean with `:packdel fff.nvim`
vim.pack.add({ 'https://github.com/dmtrKovalenko/fff' })

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'fff' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd('fff')
      end
      require('fff.download').download_or_build_binary()
    end
  end,
})

vim.g.fff = {
  lazy_sync = true,
  debug = { enabled = false, show_scores = false },
}

vim.keymap.set('n', '<leader>sf', function()
  require('fff').find_files()
end, { desc = 'FFFind files' })
vim.keymap.set('n', '<leader>sz', function()
  require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } })
end, { desc = 'Live fffuzy grep' })
vim.keymap.set({ 'n', 'x' }, '<leader>sw', function()
  require('fff').live_grep_under_cursor()
end, { desc = 'Search current word / selection' })
