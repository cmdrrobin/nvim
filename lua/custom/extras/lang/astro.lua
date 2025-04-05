return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'astro',
      })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'astro-language-server' })
    end,
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
