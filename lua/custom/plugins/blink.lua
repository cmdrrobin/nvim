return {
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },
    },
    event = 'InsertEnter',
    -- use a release tag to download pre-built binaries
    version = '1.*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
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

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- prefer always to view documentation
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
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

      signature = {
        enabled = true,
        -- do not show documentation when viewing signatures
        window = {
          show_documentation = false,
        },
      },

      -- use luasnip snippets
      snippets = {
        preset = 'luasnip',
      },

      -- use Rust when available, or fallback to lua
      -- Could use `prefer_rust`, which do the same, but without warning
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = {
      'completion',
      'sources.default',
      'sources.providers',
      'sources.per_filetype',
    },
  },
  -- catppuccin support
  {
    'catppuccin',
    optional = true,
    opts = {
      integrations = { blink_cmp = true },
    },
  },
}
