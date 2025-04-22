---@module 'lazy'
---@type LazySpec

-- A collection of small QoL plugins for Neovim
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@module 'snacks'
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    -- replaces nvimdev/dashboard-nvim
    dashboard = {
      enabled = true,
      preset = {
        header = table.concat({
          [[ ██████   █████                                ███                  ]],
          [[░░██████ ░░███                                ░░░                   ]],
          [[ ░███░███ ░███   ██████   ██████  █████ █████ ████  █████████████   ]],
          [[ ░███░░███░███  ███░░███ ███░░███░░███ ░░███ ░░███ ░░███░░███░░███  ]],
          [[ ░███ ░░██████ ░███████ ░███ ░███ ░███  ░███  ░███  ░███ ░███ ░███  ]],
          [[ ░███  ░░█████ ░███░░░  ░███ ░███ ░░███ ███   ░███  ░███ ░███ ░███  ]],
          [[ █████  ░░█████░░██████ ░░██████   ░░█████    █████ █████░███ █████ ]],
          [[░░░░░    ░░░░░  ░░░░░░   ░░░░░░     ░░░░░    ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
        }, '\n'),
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = '󰒲 ', key = 'e', desc = 'Extras', action = ':Extras', enabled = package.loaded.lazy ~= nil },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
    },
    explorer = { enabled = false },
    -- replaces lukas-reineke/indent-blankline.nvim
    indent = {
      enabled = true,
      animate = { enabled = false },
    },
    input = { enabled = false },
    -- replaces nvim-telescope/telescope.nvim
    picker = { enabled = true },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },
  keys = {
    -- stylua: ignore start
    { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files', },
    { '<leader><space>', function() Snacks.picker.buffers() end, desc = 'Buffers', },
    { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects' },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent' },
    { '<leader>fg', function() Snacks.picker.grep() end, desc = 'File Grep' },
    { '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
    { '<leader>gc', function() Snacks.picker.git_log() end, desc = 'Git Log' },
    { '<leader>gf', function() Snacks.picker.git_files() end, desc = 'Git Files' },
    -- stylua: ignore end
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
