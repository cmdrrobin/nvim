---@brief
---
---https://github.com/astral-sh/ruff
--
-- A Language Server Protocol implementation for Ruff, an extremely fast Python linter and code formatter, written in Rust. It can be installed via `pip`.
--
-- ```sh
-- pip install ruff
-- ```
--
-- **Available in Ruff `v0.4.5` in beta and stabilized in Ruff `v0.5.3`.**
--
-- This is the new built-in language server written in Rust. It supports the same feature set as `ruff-lsp`, but with superior performance and no installation required. Note that the `ruff-lsp` server will continue to be maintained until further notice.
--
-- Server settings can be provided via:
--
-- ```lua
-- vim.lsp.config('ruff', {
--   init_options = {
--     settings = {
--       -- Server settings should go here
--     }
--   }
-- })
-- ```
--
-- Refer to the [documentation](https://docs.astral.sh/ruff/editors/) for more details.
---@type vim.lsp.Config
return {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml' },
  settings = {},
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
