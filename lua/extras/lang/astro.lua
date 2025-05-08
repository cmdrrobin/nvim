return {
  recommended = {
    ft = 'astro',
    root = {
      -- https://docs.astro.build/en/guides/configuring-astro/#supported-config-file-types
      'astro.config.js',
      'astro.config.mjs',
      'astro.config.cjs',
      'astro.config.ts',
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'astro',
      })
    end,
  },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'astro-language-server' },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
