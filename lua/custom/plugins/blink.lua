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
      'sources.default',
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
