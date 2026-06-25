local add_on_event = require('vim-pack').add_on_event

add_on_event('UIEnter', {
  src = 'https://github.com/nvim-mini/mini.icons',
  on_setup = function()
    MiniIcons.mock_nvim_web_devicons()
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
