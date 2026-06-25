-- autopairs
-- https://github.com/windwp/nvim-autopairs
local add_on_event = require('vim-pack').add_on_event

add_on_event('InsertEnter', {
  src = 'https://github.com/windwp/nvim-autopairs',
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
