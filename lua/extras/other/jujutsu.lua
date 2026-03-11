---@module 'lazy'
---@type LazySpec
return {
  {
    'martintrojer/jj-fugitive',
    cmd = 'J',
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter',
    config = function()
      -- Register gitcommit parser for jjdescription filetype
      vim.treesitter.language.register('gitcommit', 'jjdescription')
    end,
  },
  {
    'acarapetis/nvim-treesitter-jjconfig',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
}
