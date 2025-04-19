-- A pretty list for showing diagnostics, references, telescope results,
-- quickfix and location lists to help you solve all the trouble your code
-- is causing.

---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    ---@module 'trouble'
    ---@class trouble.Config
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Document Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Workspace Diagnostics (Trouble)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>cS', '<cmd>Trouble lsp toggle<cr>', desc = 'LSP references/definitions/... (Trouble)' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
