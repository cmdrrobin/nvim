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
      { '<leader>a', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' } },
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'anthropic',
        },
        inline = {
          adapter = 'anthropic',
        },
        cmd = {
          adapter = 'anthropic',
        },
      },
    },
    config = function(_, opts)
      -- Validate if environment variable is set
      if not os.getenv('ANTHROPIC_API_KEY') then
        vim.notify('Environment variable ANTHROPIC_API_KEY is not set!', vim.log.levels.WARN)
      end

      require('codecompanion').setup(opts)
    end,
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
