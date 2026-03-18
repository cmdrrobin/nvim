-- highlight and search for todo comments like `TODO`, `FIXME`, `HACK`, etc.
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    vim.pack.add({
      'https://github.com/folke/todo-comments.nvim',
      'https://github.com/nvim-lua/plenary.nvim',
    })

    -- Allow keyword comments with owner. e.g.
    -- KEYWORD(robin): this is a message
    require('todo-comments').setup({
      signs = false,
      search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
      highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] },
    })
  end,

  -- stylua: ignore start
  vim.keymap.set('n', ']t', function() require('todo-comments').jump_next() end, { desc = 'Next todo comment' }),
  vim.keymap.set('n', '[t', function() require('todo-comments').jump_prev() end, { desc = 'Previous todo comment' }),
  vim.keymap.set('n', '<leader>xt', '<cmd>TodoTrouble<cr>', { desc = 'Todo (Trouble)' }),
  vim.keymap.set('n', '<leader>ft', '<cmd>TodoTelescope keywords=TODO,FIX,HACK<CR>', { desc = 'Telescope: [F]ind [T]odo' }),
  -- stylua: ignore end
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
