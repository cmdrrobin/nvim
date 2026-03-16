vim.pack.add({ 'https://github.com/folke/snacks.nvim' })

---@module 'snacks'
---@type snacks.Config
require('snacks').setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  bigfile = { enabled = true },
  -- replaces nvimdev/dashboard-nvim
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys",  gap = 1, padding = 1 },
    },
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
  image = {
    enabled = vim.g.snacks_image,
    -- NOTE(robin): disable image processing for docs
    doc = {
      enabled = false,
    },
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
})
-- HACK(robin): when snacks image is disabled, do not try to load the image
-- in the picker previewer. Without the following function, it will trigger
-- error message.
-- https://github.com/folke/snacks.nvim/discussions/1787

-- Check if the file format is supported
---@type function
local supports_file = require('snacks.image').supports_file
---@param file string
Snacks.image.supports_file = function(file)
  if not Snacks.image.config.enabled then
    return false
  end
  return supports_file(file)
end

-- stylua: ignore start
vim.keymap.set('n', '<leader>ff', function() Snacks.picker.files() end, { desc = 'Find Files' })
vim.keymap.set('n', '<leader><space>', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fp', function() Snacks.picker.projects() end, { desc = 'Projects' })
vim.keymap.set('n', '<leader>fr', function() Snacks.picker.recent() end, { desc = 'Recent' })
vim.keymap.set('n', '<leader>fg', function() Snacks.picker.grep() end, { desc = 'File Grep' })
vim.keymap.set('n', '<leader>gb', function() Snacks.picker.git_branches() end, { desc = 'Git Branches' })
vim.keymap.set('n', '<leader>gc', function() Snacks.picker.git_log() end, { desc = 'Git Log' })
vim.keymap.set('n', '<leader>gf', function() Snacks.picker.git_files() end, { desc = 'Git Files' })
-- stylua: ignore end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
