return {
  -- Add a bunch of pre-configured snippets. Custom snippets can be added to
  -- the `snippets/` folder in the root of the project.
  'L3MON4D3/LuaSnip',
  event = { 'InsertEnter' },
  dependencies = {
    'rafamadriz/friendly-snippets',
    event = 'InsertEnter',
    config = function()
      local snippets = require('luasnip.loaders.from_vscode')
      snippets.lazy_load()
      snippets.lazy_load({ paths = { './snippets' } })
    end,
  },
}
