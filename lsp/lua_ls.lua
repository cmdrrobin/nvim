return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', vim.uv.cwd() },
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'opt', 'cmd' },
      },
      completion = {
        callSnippet = 'Replace',
      },
    },
    runtime = {
      version = 'LuaJIT',
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
