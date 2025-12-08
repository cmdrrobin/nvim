return {
  recommended = {
    ft = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    root = { 'tsconfig.json', 'package.json', 'jsconfig.json' },
  },
  -- Ensure Typescript tools are installed
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'typescript-language-server' },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
