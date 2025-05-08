---@module 'lazy'
---@type LazySpec
return {
  {
    -- Main LSP Configuration
    'mason-org/mason-lspconfig.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'mason-org/mason.nvim' },
    },
    opts_extend = { 'ensure_installed' },
    ---@module 'mason-lspconfig.settings'
    ---@type MasonLspconfigSettings
    opts = {
      ensure_installed = { 'lua_ls' },
      automatic_installation = false,
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
