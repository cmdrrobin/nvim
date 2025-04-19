---@module 'lazy'
---@type LazySpec
return {
  {
    -- Main LSP Configuration
    'williamboman/mason-lspconfig.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'williamboman/mason.nvim' },
    },
    opts_extend = { 'ensure_installed' },
    opts = {
      ensure_installed = { 'lua_ls' },
      automatic_installation = false,
    },
    config = function(_, opts)
      ---@module 'mason-lspconfig'
      ---@type MasonLspconfigSettings
      require('mason-lspconfig').setup(opts)

      -- enable each LSP server
      for _, server_name in pairs(opts.ensure_installed) do
        vim.lsp.enable(server_name)
      end
    end,
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
