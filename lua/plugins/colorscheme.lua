---@module 'lazy'
---@type LazySpec
return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
    'rose-pine/neovim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    name = 'rose-pine',
    ---@module 'rose-pine'
    ---@type Options
    opts = {
      -- Differentiate between active and inactive windows and panels
      dim_inactive_windows = true,

      highlight_groups = {
        -- vim-illuminate custom colors
        IlluminatedWordText = { bg = 'highlight_med', blend = 40 },
        IlluminatedWordRead = { bg = 'highlight_med', blend = 40 },
        IlluminatedWordWrite = { bg = 'highlight_med', blend = 40 },

        -- Give Telescope titles own color
        TelescopeTitle = { fg = 'base', bg = 'love' },
        TelescopePromptTitle = { fg = 'base', bg = 'rose' },
        TelescopePreviewTitle = { fg = 'base', bg = 'iris' },

        -- Give Snacks Picker titles own color
        SnacksPickerTitle = { fg = 'base', bg = 'love' },
        SnacksPickerInputTitle = { fg = 'base', bg = 'rose' },
        SnacksPickerPreviewTitle = { fg = 'base', bg = 'iris' },
      },
    },
    config = function(_, opts)
      require('rose-pine').setup(opts)
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'rose-pine-main', 'rose-pine-moon', or 'rose-pine-dawn'.
      vim.cmd.colorscheme('rose-pine')
    end,
  },
}
