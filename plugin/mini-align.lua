local add_on_event = require('vim-pack').add_on_event

add_on_event({ 'BufReadPre', 'BufNewFile' }, {
  src = 'https://github.com/nvim-mini/mini.align',
  version = vim.version.range('*'),
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
