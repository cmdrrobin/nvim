local root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  'pyrightconfig.json',
}

-- local function organize_imports()
--   local params = {
--     command = 'basedpyright.organizeimports',
--     arguments = { vim.uri_from_bufnr(0) },
--   }
--
--   local clients = vim.lsp.get_clients({
--     bufnr = vim.api.nvim_get_current_buf(),
--     name = 'basedpyright',
--   })
--   for _, client in ipairs(clients) do
--     client.request('workspace/executeCommand', params, nil, 0)
--   end
-- end

-- local function set_python_path(path)
--   local clients = vim.lsp.get_clients({
--     bufnr = vim.api.nvim_get_current_buf(),
--     name = 'basedpyright',
--   })
--   for _, client in ipairs(clients) do
--     if client.settings then
--       client.settings.python = vim.tbl_deep_extend('force', client.settings.python or {}, { pythonPath = path })
--     else
--       client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
--     end
--     client.notify('workspace/didChangeConfiguration', { settings = nil })
--   end
-- end

---@brief
---
---https://detachhead.github.io/basedpyright
--
-- `basedpyright`, a static type checker and language server for python
---@type vim.lsp.Config
return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = root_files,
  settings = {
    basedpyright = {
      disableOrganizeImports = false,
      typeCheckingMode = 'standard',
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
    python = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        typeCheckingMode = 'basic',
        diagnosticMode = 'workspace',
        useLibraryCodeForTypes = true,
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
        },
      },
    },
  },
  -- on_attach = function()
  --   vim.api.nvim_buf_create_user_command(0, 'PyrightOrganizeImports', organize_imports, {
  --     desc = 'Organize Imports',
  --   })
  --
  --   vim.api.nvim_buf_create_user_command(0, 'PyrightSetPythonPath', set_python_path, {
  --     desc = 'Reconfigure basedpyright with the provided python path',
  --     nargs = 1,
  --     complete = 'file',
  --   })
  -- end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
