-- Undotree visualizes the undo history and makes it easy to browse and switch
-- between different undo branches.

---@module 'lazy'
---@type LazySpec
return {
  {
    'mbbill/undotree',
    event = { 'BufReadPost', 'BufNewFile' },
    keys = {
      { '<leader>u', '<cmd>UndotreeToggle<CR>', desc = 'Toggle Undotree' },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
