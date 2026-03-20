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
  init_options = {
    provideFormatter = true,
    schemas = not schemas and true or schemas,
    validate = { enable = true },
  },
}
