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

-- NOTE(robin): fff pins the preview target line with an extmark using
-- `line_hl_group = 'CursorLine'`. Neovim lets a `line_hl_group` background
-- override every `hl_group` background on that line regardless of priority,
-- so the grep match (IncSearch) loses its bg on the target line (in fuzzy mode
-- that is the *only* highlighted line). Re-create those extmarks as low
-- priority full-width range highlights so the match highlight wins.
-- See https://github.com/dmtrKovalenko/fff/issues/646
-- Remove the following code when PR https://github.com/dmtrKovalenko/fff/pull/886
-- is merged.
do
  local location_utils = require('fff.location_utils')
  local highlight_location = location_utils.highlight_location

  location_utils.highlight_location = function(bufnr, location, namespace)
    local result = highlight_location(bufnr, location, namespace)
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return result
    end

    local marks = vim.api.nvim_buf_get_extmarks(bufnr, namespace, 0, -1, { details = true })
    for _, mark in ipairs(marks) do
      local id, row, col, d = mark[1], mark[2], mark[3], mark[4]
      if d and d.line_hl_group then
        -- Keep everything except the line highlight on the original extmark
        vim.api.nvim_buf_set_extmark(bufnr, namespace, row, col, {
          id = id,
          end_row = d.end_row,
          end_col = d.end_col,
          hl_group = d.hl_group,
          number_hl_group = d.number_hl_group,
          priority = d.priority,
        })
        -- Emulate the line highlight with a range highlight below the match
        pcall(vim.api.nvim_buf_set_extmark, bufnr, namespace, row, 0, {
          end_row = row + 1,
          end_col = 0,
          hl_eol = true,
          hl_group = d.line_hl_group,
          priority = 50,
        })
      end
    end

    return result
  end
end

-- stylua: ignore start
vim.keymap.set('n', '<leader>ff', function() require('fff').find_files() end, { desc = 'FFFind files' })
vim.keymap.set('n', '<leader>fg', function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end, { desc = 'Live fffuzy grep' })
vim.keymap.set({ 'n', 'x' }, '<leader>fw', function() require('fff').live_grep_under_cursor() end, { desc = 'Search current word / selection' })
-- stylua: ignore end
