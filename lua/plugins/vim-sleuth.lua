---@module "lazy"

---@type LazySpec
return {
  'tpope/vim-sleuth',
  enabled = true,
  event = { 'BufNewFile', 'BufReadPre' },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
