---@type table<string>
local enable_lsp = {
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

vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' }, { confirm = false })

vim.lsp.enable(enable_lsp)
