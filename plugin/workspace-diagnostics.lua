vim.pack.add({
  { src = 'https://github.com/artemave/workspace-diagnostics.nvim' },
}, { load = false })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function()
    vim.cmd.packadd('workspace-diagnostics.nvim')
    vim.lsp.config('*', {
      on_attach = function(client, bufnr)
        -- some clients support workspace diagnostics natively
        if client:supports_method('workspace/diagnostic', bufnr) then
          vim.lsp.buf.workspace_diagnostics({ client_id = client.id })
        else
          require('workspace-diagnostics').populate_workspace_diagnostics(client, bufnr)
        end
      end,
    })
  end,
})
