return {
  recommended = {
    ft = 'dockerfile',
    root = { 'Dockerfile', 'docker-compose.yml', 'compose.yml', 'docker-compose.yaml', 'compose.yaml' },
  },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'dockerls', 'docker_compose_language_service', 'hadolint' },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
