-- AI-powered coding
return {
  {
    'olimorris/codecompanion.nvim',
    cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionChat' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim', -- Optional: For using slash commands
    },
    keys = {
      { '<C-a>', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' } },
      { '<leader>a', '<cmd>CodeCompanionChat Toggle<cr>' },
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'anthropic',
        },
        inline = {
          adapter = 'anthropic',
        },
      },
    },
    config = function(_, opts)
      require('codecompanion').setup(opts)
    end,
  },
  -- blink.cmp integration
  {
    'saghen/blink.cmp',
    optional = true,
    opts = {
      sources = {
        per_filetype = {
          codecompanion = {
            'codecompanion',
            'lsp',
            'path',
            'buffer',
          },
        },
      },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
