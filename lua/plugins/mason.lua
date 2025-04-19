---@module 'lazy'
---@type LazySpec
return {
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    build = ':MasonUpdate',
    opts_extend = { 'ensure_installed' },
    ---@module 'mason.settings'
    ---@type MasonSettings
    opts = {
      ensure_installed = {
        'stylua',
        'shfmt',
      },
    },
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require('mason-registry')

      mr:on('package:install:success', function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require('lazy.core.handler.event').trigger({
            event = 'FileType',
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      -- check if packages need to be installed
      mr.refresh(function()
        for _, pkg_name in ipairs(opts.ensure_installed) do
          local pkg = mr.get_package(pkg_name)
          if not pkg:is_installed() then
            pkg:install()
          else
            -- update installed package to latest version
            pkg:check_new_version(function(success, result_or_err)
              if success then
                pkg:install({ version = result_or_err.latest_version })
              end
            end)
          end
        end
      end)
    end,
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
