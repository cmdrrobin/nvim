-- Refer to the [documentation](https://docs.astral.sh/ruff/editors/) for more details.
---@type vim.lsp.Config
return {
  cmd_env = { RUFF_TRACE = 'messages' },
  init_options = {
    settings = {
      logLevel = 'error',
    },
  },
  on_attach = function(client, _)
    -- Disable hover in favor of (based)pyright
    client.server_capabilities.hoverProvider = false
  end,
  keys = {
    {
      '<leader>co',
      function()
        vim.lsp.buf.code_action({
          apply = true,
          context = {
            only = { 'source.organizeImports' },
            diagnostics = {},
          },
        })
      end,
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
