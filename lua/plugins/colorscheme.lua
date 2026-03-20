vim.pack.add({
  { src = 'https://github.com/rose-pine/neovim', name = 'rose-pine' },
}, { confirm = false })
---@module 'rose-pine'
---@type Options
require('rose-pine').setup({
  -- Differentiate between active and inactive windows and panels
  dim_inactive_windows = true,

  highlight_groups = {
    -- vim-illuminate custom colors
    IlluminatedWordText = { bg = 'highlight_med', blend = 40 },
    IlluminatedWordRead = { bg = 'highlight_med', blend = 40 },
    IlluminatedWordWrite = { bg = 'highlight_med', blend = 40 },

    -- Give Telescope titles own color
    TelescopeTitle = { fg = 'base', bg = 'love' },
    TelescopePromptTitle = { fg = 'base', bg = 'rose' },
    TelescopePreviewTitle = { fg = 'base', bg = 'iris' },

    -- Give Snacks Picker titles own color
    SnacksPickerTitle = { fg = 'base', bg = 'love' },
    SnacksPickerInputTitle = { fg = 'base', bg = 'rose' },
    SnacksPickerPreviewTitle = { fg = 'base', bg = 'iris' },
  },
})
-- Load the colorscheme here.
-- Like many other themes, this one has different styles, and you could load
-- any other, such as 'rose-pine-main', 'rose-pine-moon', or 'rose-pine-dawn'.
vim.cmd.colorscheme('rose-pine')
