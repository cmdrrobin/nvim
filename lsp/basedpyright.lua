---@brief
---
---https://detachhead.github.io/basedpyright
--
-- `basedpyright`, a static type checker and language server for python
---@type vim.lsp.Config
return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
  },
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
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightOrganizeImports', function()
      client:exec_cmd({
        command = 'basedpyright.organizeimports',
        arguments = { vim.uri_from_bufnr(bufnr) },
      })
    end, {
      desc = 'Organize Imports',
    })
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
