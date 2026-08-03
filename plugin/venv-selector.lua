local add_on_file_type = require('vim-pack').add_on_file_type

add_on_file_type('python', {
  {
    src = 'https://github.com/linux-cultist/venv-selector.nvim',
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
