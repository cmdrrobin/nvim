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
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'mypy' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              disableOrganizeImports = false,
              typeCheckingMode = 'standard',
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
        ruff = {
          cmd_env = { RUFF_TRACE = 'messages' },
          init_options = {
            settings = {
              logLevel = 'error',
            },
          },
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
        },
      },
    },
    setup = {
      ruff = function()
        require('custom.functions').on_attach(function(client, _)
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end, 'ruff')
      end,
    },
  },
  {
    'mfussenegger/nvim-lint',
    optional = true,
    opts = {
      linters_by_ft = {
        python = { 'mypy' },
      },
    },
  },
  {
    -- use own debugging language
    'mfussenegger/nvim-dap-python',
    dependencies = { 'mfussenegger/nvim-dap' },
    ft = 'python',
    config = function()
      local dap_python = require('dap-python')
      local mason_path = vim.fn.glob(vim.fn.stdpath('data') .. '/mason/')

      dap_python.setup(mason_path .. 'packages/debugpy/venv/bin/python')

      dap_python.test_runner = 'pytest'
    end,
  },
  {
    'nvim-neotest/neotest',
    optional = true,
    dependencies = {
      'nvim-neotest/neotest-python',
    },
    opts = {
      adapters = {
        ['neotest-python'] = {},
      },
    },
  },
  {
    'linux-cultist/venv-selector.nvim',
    cmd = 'VenvSelect',
    branch = 'regexp',
    ft = 'python',
    opts = {},
    keys = { { '<leader>cv', '<cmd>:VenvSelect<cr>', desc = 'Select VirtualEnv' } },
  },
  {
    'andythigpen/nvim-coverage',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = 'nvim-lua/plenary.nvim',
    ft = 'python',
    opts = {},
  },
  {
    'hrsh7th/nvim-cmp',
    enabled = false,
    opts = function(_, opts)
      opts.auto_brackets = opts.auto_brackets or {}
      table.insert(opts.auto_brackets, 'python')
    end,
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
