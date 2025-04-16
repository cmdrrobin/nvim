return {
  -- Plugin: Markdown Previewer
  {
    'iamcco/markdown-preview.nvim',
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
    keys = {
      { '<leader>mp', '<cmd>MarkdownPreview<CR>', { silent = true, desc = '[M]arkdown [P]review' } },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
