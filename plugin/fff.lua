--- A file search toolkit for humans and AI agents. Really fast.
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
  prompt = '❯ ',
  keymaps = {
    close = '<Esc>',
    select = '<CR>',
    move_up = { '<Up>', '<C-p>' },
    move_down = { '<Down>', '<C-n>' },
    preview_scroll_up = '<C-u>',
    preview_scroll_down = '<C-d>',
    toggle_select = '<Tab>',
    send_to_quickfix = '<C-q>',
    focus_list = '<leader>l',
    focus_preview = '<leader>p',
    git = {
      status_text_color = true,
    },
  },
}

-- stylua: ignore start
vim.keymap.set('n', '<leader>ff', function() require('fff').find_files() end, { desc = 'FFFind files' })
vim.keymap.set('n', '<leader>fg', function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end, { desc = 'Live fffuzy grep' })
vim.keymap.set({ 'n', 'x' }, '<leader>fw', function() require('fff').live_grep_under_cursor() end, { desc = 'Search current word / selection' })
-- stylua: ignore end
