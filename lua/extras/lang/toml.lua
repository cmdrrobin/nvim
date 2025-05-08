return {
  recommended = {
    ft = 'toml',
    root = '*.toml',
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'toml',
      })
    end,
  },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'taplo' },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
