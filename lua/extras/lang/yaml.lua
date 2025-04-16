return {
  recommended = {
    ft = 'yaml',
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'yaml',
      })
    end,
  },
  -- yaml schema support
  {
    'b0o/SchemaStore.nvim',
    lazy = true,
    version = false, -- last release is way too old
  },
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'yamlls' },
    },
  },
}

-- The line beneath this is calle `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
