---@type vim.lsp.Config
return {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  init_options = {
    provideFormatter = true,
    schemas = require('schemastore').json.schemas(),
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
