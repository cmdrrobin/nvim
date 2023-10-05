return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'python',
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        pyright = {
          settings = {
            pyright = {
              disableLanguageServices = false,
              disableOrganizeImports = false
            },
            python = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                typeCheckingMode = 'basic',
                diagnosticMode = 'workspace',
                useLibraryCodeForTypes = true,
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                },
              },
            },
          },
        },
      },
    },
  },
  {
    'nvimtools/none-ls.nvim',
    optional = true,
    opts = function(_, opts)
      if type(opts.sources) == 'table' then
        local nonels = require('null-ls')
        vim.list_extend(opts.sources, {
          nonels.builtins.formatting.black.with { extra_args = { '--fast' } },
        })
      end
    end,
  },
  {
    -- use own debugging language
    'mfussenegger/nvim-dap-python',
    dependencies = { 'mfussenegger/nvim-dap' },
    ft = 'python',
    config = function()
      local dap_python = require('dap-python')
      local mason_path = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/')

      dap_python.setup(mason_path .. 'packages/debugpy/venv/bin/python')

      dap_python.test_runner = 'pytest'
    end,
  },
  {
    'nvim-neotest/neotest-python',
    ft = 'python',
    dependencies = {
      'nvim-neotest/neotest',
    },
    keys = {
      { '<leader>tm', "<cmd>lua require('neotest').run.run()<cr>",
        { desc = 'Test Method' }
      },
      { '<leader>tM', "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
        { desc = 'Test Method DAP' }
      },
      { '<leader>tf', "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>",
        { desc = 'Test Class' }
      },
      { '<leader>tF', "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
        { desc = 'Test Class DAP' }
      },
      { '<leader>tS', "<cmd>lua require('neotest').summary.toggle()<cr>",
        { desc = 'Test Summary' }
      },
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          dap = {
            justMyCode = false,
            console = 'integratedTerminal',
          },
          args = { '--log-level', 'DEBUG', '--quiet' },
          runner = 'pytest',
        },
      },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
