local add_on_file_type = require('vim-pack').add_on_file_type
local on_plugin_update = require('vim-pack').on_plugin_update

-- Markdown preview on the browser.
add_on_file_type('markdown', {
  {
    src = 'https://github.com/iamcco/markdown-preview.nvim',
    -- Vimscript-driven plugin: no Lua setup() to call.
    setup = false,
    on_setup = function()
      vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', {
        desc = 'Markdown Preview',
      })
    end,
  },
})

on_plugin_update('markdown-preview.nvim', function()
  vim.fn['mkdp#util#install_sync'](true)
end)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
