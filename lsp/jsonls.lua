---@type (boolean|table)
local schemas
local schemastore_ok, schemastore = pcall(require, 'schemastore')
if schemastore_ok then
  schemas = schemastore.yaml.schemas()
else
  schemas = false
end

---@type vim.lsp.Config
return {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  init_options = {
    provideFormatter = true,
    schemas = not schemas and true or schemas,
    validate = { enable = true },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
