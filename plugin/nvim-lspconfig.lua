local add = require('vim-pack').add

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

add({
  {
    src = 'https://github.com/neovim/nvim-lspconfig',
    name = 'lspconfig',
    setup = false,
    on_setup = function()
      vim.lsp.enable(enable_lsp)
    end,
  },
})
