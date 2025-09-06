-- Align text interactively

---@module 'lazy'
---@type LazySpec
return {
  'nvim-mini/mini.align',
  version = '*',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {},
  config = function(opts)
    require('mini.align').setup(opts)
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
