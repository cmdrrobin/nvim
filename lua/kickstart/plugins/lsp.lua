return {
  -- LSP Plugins
  {
    -- Main LSP Configuration
    'williamboman/mason-lspconfig.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      -- { 'j-hui/fidget.nvim', opts = {} },
    },
    opts = {
      -- TODO: comments for installing LSP
      ensure_installed = { 'lua_ls' },
      automatic_installation = true,
    },
    config = function(_, opts)
      -- Brief Aside: **What is LSP?**
      --
      -- LSP is an acronym you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu
      require('mason').setup()

      ---@module 'mason-lspconfig'
      ---@type MasonLspconfigSettings
      require('mason-lspconfig').setup(opts)
    end,
  },
}
