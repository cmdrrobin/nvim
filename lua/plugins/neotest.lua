-- Neotest to test your code
return {
  {
    'nvim-neotest/neotest',
    opts = {
      adapters = {},
    },
    config = function(_, opts)
      -- if adapters option is set, load it!
      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == 'number' then
            if type(config) == 'string' then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == 'table' and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter(config)
              else
                error('Adapter ' .. name .. ' does not support setup')
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require('neotest').setup(opts)
    end,
    keys = {
      { '<leader>tm', "<cmd>lua require('neotest').run.run()<cr>", desc = 'Test Method' },
      { '<leader>tM', "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = 'Test Method DAP' },
      { '<leader>tf', "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", desc = 'Test Class' },
      {
        '<leader>tF',
        "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
        desc = 'Test Class DAP',
      },
      { '<leader>tS', "<cmd>lua require('neotest').summary.toggle()<cr>", desc = 'Test Summary' },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
