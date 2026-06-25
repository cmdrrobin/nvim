-- enhanced builtin nvim comments
local add_on_event = require('vim-pack').add_on_event

add_on_event('BufReadPost', {
  src = 'https://github.com/folke/ts-comments.nvim',
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
