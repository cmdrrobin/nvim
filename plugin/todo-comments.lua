-- highlight and search for todo comments like `TODO`, `FIXME`, `HACK`, etc.
local add_on_event = require('vim-pack').add_on_event

add_on_event({ 'BufReadPre', 'BufNewFile' }, {
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  {
    src = 'https://github.com/folke/todo-comments.nvim',
    opts = {
      signs = false,
      search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
      highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] },
    },
    on_setup = function()
      -- stylua: ignore start
      vim.keymap.set('n', ']t', function() require('todo-comments').jump_next() end, { desc = 'Next todo comment' })
      vim.keymap.set('n', '[t', function() require('todo-comments').jump_prev() end, { desc = 'Previous todo comment' })
      vim.keymap.set('n', '<leader>xt', '<cmd>TodoTrouble<cr>', { desc = 'Todo (Trouble)' })
      vim.keymap.set('n', '<leader>ft', '<cmd>TodoTelescope keywords=TODO,FIX,HACK<CR>', { desc = 'Telescope: [F]ind [T]odo' })
      -- stylua: ignore end
    end,
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
