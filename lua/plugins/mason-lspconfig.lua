-- List of lsp to be installed
---@type table<string>
local ensure_installed = {
  'lua_ls',
  'stylua',
  'ruff',
  'ty',
  'bashls',
  'gopls',
  'ts_ls',
  'jsonls',
  'dockerls',
  'docker_compose_language_service',
  'taplo',
  'yamlls',
  'ansiblels',
}

vim.pack.add({ 'https://github.com/mason-org/mason-lspconfig.nvim' })

require('mason-lspconfig').setup({
  ensure_installed = ensure_installed,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
