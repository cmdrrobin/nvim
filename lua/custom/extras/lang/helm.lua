return {
  {
    'towolf/vim-helm',
    commit = 'fc2259e', -- FIXME: there is an issue with gitlab-ci yaml files. This version works
    ft = 'helm',
  },
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'helm-ls' })
    end,
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
