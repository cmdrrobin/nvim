-- Bring AI to Neovim with Github Copilot.
-- GitHub Copilot uses OpenAI Codex to suggest code and entire functions in
-- real-time right from your editor. Trained on billions of lines of public code,
-- GitHub Copilot turns natural language prompts including comments and method
-- names into coding suggestions across dozens of languages.
return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
    config = function(_, opts)
      require('copilot').setup(opts)
      vim.keymap.set('n', '<leader>ct', '<CMD>Copilot toggle<CR>', { desc = 'Toggle Github Copilot', silent = true })
    end,
  },
  -- Update lualine to show copilot status
  {
    'nvim-lualine/lualine.nvim',
    optional = true,
    event = 'VeryLazy',
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 2, {
        function()
          local icon = require('icons').kind.Copilot
          local status = require('copilot.api').status.data
          return icon .. (status.message or '') .. ' '
        end,
        cond = function()
          local ok, clients = pcall(vim.lsp.get_clients, { name = 'copilot', bufnr = 0 })
          return ok and #clients > 0
        end,
        padding = { left = 1, right = 1 },
      })
    end,
  },
  {
    'saghen/blink.cmp',
    optional = true,
    dependencies = { 'giuxtaposition/blink-cmp-copilot' },
    opts = {
      sources = {
        default = { 'copilot' },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-cmp-copilot',
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
