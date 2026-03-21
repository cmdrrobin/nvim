-- List of lsp to be installed
---@type table<string>
local ensure_installed = {
  'ansiblels',
  'bashls',
  'docker_compose_language_service',
  'dockerls',
  'gopls',
  'jsonls',
  'lua_ls',
  'ruff',
  'stylua',
  'taplo',
  'terraformls',
  'ts_ls',
  'ty',
  'yamlls',
}

vim.pack.add({ 'https://github.com/mason-org/mason-lspconfig.nvim' }, { confirm = false })

require('mason-lspconfig').setup({
  ensure_installed = ensure_installed,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
