-- show context of current cursor position

---@module 'lazy'
---@type LazySpec
return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-context',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      throttle = true, -- Throttles plugin updates (may improve performance)
      max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
      multiline_threshold = 1, -- Match the context lines to the source code.
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
