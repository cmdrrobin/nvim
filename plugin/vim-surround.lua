local add_on_event = require('vim-pack').add_on_event

add_on_event({ 'BufReadPre', 'BufNewFile' }, {
  src = 'https://github.com/tpope/vim-surround',
})
