---@type vim.lsp.Config
return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml' },
  settings = {
    yaml = {
      format = { enable = false }, -- don't let yamlls format
      validate = true,
      -- Using the schemastore plugin for schemas.
      schemastore = { enable = false, url = '' },
    },
  },
}
