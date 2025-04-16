return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'go',
      })
    end,
  },
  -- Ensure Go tools are installed
  {
    'williamboman/mason.nvim',
    opts = {
      ensure_installed = { 'goimports', 'gofumpt' },
    },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'gopls' },
    },
  },
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        go = { 'goimports', 'gofumpt' },
      },
    },
  },
  {
    'nvim-neotest/neotest',
    optional = true,
    dependencies = {
      'nvim-neotest/neotest-go',
    },
    opts = {
      adapters = {
        ['neotest-go'] = {},
      },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
