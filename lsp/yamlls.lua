---@brief
---
---https://github.com/redhat-developer/yaml-language-server
--
-- `yaml-language-server` can be installed via `yarn`:
-- ```sh
-- yarn global add yaml-language-server
-- ```
--
-- To use a schema for validation, there are two options:
--
-- 1. Add a modeline to the file. A modeline is a comment of the form:
--
-- ```
-- # yaml-language-server: $schema=<urlToTheSchema|relativeFilePath|absoluteFilePath}>
-- ```
--
-- where the relative filepath is the path relative to the open yaml file, and the absolute filepath
-- is the filepath relative to the filesystem root ('/' on unix systems)
--
-- 2. Associated a schema url, relative , or absolute (to root of project, not to filesystem root) path to
-- the a glob pattern relative to the detected project root. Check `:checkhealth vim.lsp` to determine the resolved project
-- root.
--
-- ```lua
-- vim.lsp.config('yamlls', {
--   ... -- other configuration for setup {}
--   settings = {
--     yaml = {
--       ... -- other settings. note this overrides the lspconfig defaults.
--       schemas = {
--         ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
--         ["../path/relative/to/file.yml"] = "/.github/workflows/*",
--         ["/path/from/root/of/project"] = "/.github/workflows/*",
--       },
--     },
--   }
-- })
-- ```
--
-- Currently, kubernetes is special-cased in yammls, see the following upstream issues:
-- * [#211](https://github.com/redhat-developer/yaml-language-server/issues/211).
-- * [#307](https://github.com/redhat-developer/yaml-language-server/issues/307).
--
-- To override a schema to use a specific k8s schema version (for example, to use 1.18):
--
-- ```lua
-- vim.lsp.config('yamlls', {
--   ... -- other configuration for setup {}
--   settings = {
--     yaml = {
--       ... -- other settings. note this overrides the lspconfig defaults.
--       schemas = {
--         ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/v1.32.1-standalone-strict/all.json"] = "/*.k8s.yaml",
--         ... -- other schemas
--       },
--     },
--   }
-- })
-- ```

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
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab', 'yaml.helm-values' },
  root_markers = { '.git' },
  settings = {
    -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
    redhat = { telemetry = { enabled = false } },
    yaml = {
      keyOrdering = false,
      format = {
        enable = true,
      },
      validate = true,
      schemaStore = {
        -- Must disable built-in schemaStore support to use schemas from SchemaStore.nvim plugin
        enable = not schemas and true or false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = '',
      },
      schemas = schemas,
    },
  },
  on_init = function(client)
    --- https://github.com/neovim/nvim-lspconfig/pull/4016
    --- Since formatting is disabled by default if you check `client:supports_method('textDocument/formatting')`
    --- during `LspAttach` it will return `false`. This hack sets the capability to `true` to facilitate
    --- autocmd's which check this capability
    client.server_capabilities.documentFormattingProvider = true
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
