local icons = require('icons')

---@module 'lazy'
---@type LazySpec
return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    event = { 'BufReadPre', 'BufNewFile' },
    enabled = false,
    main = 'ibl',
    ---@module 'ibl'
    ---@type ibl.config
    opts = {
      indent = {
        char = icons.misc.VerticalBar,
        tab_char = icons.misc.VerticalBar,
      },
      scope = {
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          'help',
          'dashboard',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
        },
      },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
