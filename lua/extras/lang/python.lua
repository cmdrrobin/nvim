return {
  recommended = {
    ft = 'python',
    root = {
      'pyproject.toml',
      'requirements.txt',
    },
  },
  {
    'mason-org/mason.nvim',
    opts = {
      ensure_installed = { 'mypy' },
    },
  },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'basedpyright', 'ruff' },
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
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
