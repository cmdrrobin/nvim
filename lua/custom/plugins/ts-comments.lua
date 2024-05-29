-- enhanced builtin nvim comments
return {
  'folke/ts-comments.nvim',
  event = 'VeryLazy',
  opts = {},
  enabled = vim.fn.has('nvim-0.10') == 1,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
