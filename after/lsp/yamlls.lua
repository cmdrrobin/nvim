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
  settings = {
    yaml = {
      format = {
        enable = false,
      },
      schemaStore = {
        -- Must disable built-in schemaStore support to use schemas from SchemaStore.nvim plugin
        enable = not schemas and true or false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = '',
      },
      schemas = schemas,
    },
  },
}
