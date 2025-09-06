---@module 'lazy'
---@type LazySpec
return {
  'nvim-mini/mini.icons',
  opts = {},
  config = function(_, opts)
    require('mini.icons').setup(opts)
    MiniIcons.mock_nvim_web_devicons()
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
