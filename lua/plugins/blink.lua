vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    vim.pack.add({
      { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') },
    })

    local blink = require('blink.cmp')
    blink.setup({
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = 'enter' },

      completion = {
        -- prefer always to view documentation
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = 'padded',
          },
        },
        menu = {
          border = 'padded',
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        -- Disable some sources in comments and strings.
        default = function()
          local sources = { 'lsp', 'buffer' }
          local ok, node = pcall(vim.treesitter.get_node)

          if ok and node then
            if not vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
              table.insert(sources, 'path')
            end
            if node:type() ~= 'string' then
              table.insert(sources, 'snippets')
            end
          end

          return sources
        end,

        per_filetype = { gitcommit = { 'buffer', 'snippets' } },

        providers = {
          lsp = {
            name = 'lsp',
            enabled = true,
            module = 'blink.cmp.sources.lsp',
            score_offset = 90, -- the higher the number, the higher the priority
          },
          path = {
            name = 'Path',
            enabled = true,
            module = 'blink.cmp.sources.path',
            score_offset = 25,
            -- When typing a path, I would get snippets and text in the
            -- suggestions, I want those to show only if there are no path
            -- suggestions
            fallbacks = { 'snippets', 'buffer' },
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              get_cwd = function(context)
                return vim.fn.expand(('#%d:p:h'):format(context.bufnr))
              end,
              show_hidden_files_by_default = true,
            },
          },
          buffer = {
            name = 'Buffer',
            enabled = true,
            max_items = 3,
            module = 'blink.cmp.sources.buffer',
            min_keyword_length = 2,
            score_offset = 15, -- the higher the number, the higher the priority
          },
        },
      },

      -- I like the information, not sure if I want to have it every time
      -- Keep it on for now...
      signature = {
        enabled = true,
        -- do not show documentation when viewing signatures
        window = {
          border = 'solid',
          show_documentation = false,
        },
      },

      -- Disable command line completion
      cmdline = { enabled = false },

      -- use Rust when available, or fallback to lua
      -- Could use `prefer_rust`, which do the same, but without warning
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    })

    -- Extend neovim's client capabilities with the completion ones.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, blink.get_lsp_capabilities(nil, false))

    -- When required, add some custom capabilities settings
    capabilities = vim.tbl_deep_extend('force', capabilities, {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true,
          },
        },
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    })

    vim.lsp.config('*', { capabilities = capabilities })
  end,
})

-- Collect snippets later
vim.schedule(function()
  vim.pack.add({ 'https://github.com/rafamadriz/friendly-snippets' })
end)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
