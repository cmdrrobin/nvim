---@brief
---
---https://taplo.tamasfe.dev/cli/usage/language-server.html
--
-- Language server for Taplo, a TOML toolkit.
--
-- `taplo-cli` can be installed via `cargo`:
-- ```sh
-- cargo install --features lsp --locked taplo-cli
-- ```
---@type vim.lsp.Config
return {
  cmd = { 'taplo', 'lsp', 'stdio' },
  filetypes = { 'toml' },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
