---@module 'lazy'
---@type LazySpec
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    linters_by_ft = {
      -- See nvim-lint repo for more information ~ https://github.com/mfussenegger/nvim-lint#usage
    },
  },
  config = function(_, opts)
    local lint = require('lint')

    lint.linters_by_ft = opts.linters_by_ft

    -- create autocmd on events for firing nvim-lint
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
      group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
      callback = function()
        -- Do not execute linting on read-only buffers. This can get quite
        -- annoying when (e.g.) entering a LSP hover window.
        -- Besides that, there is no point for linting on read-only buffers.
        -- They cannot be updated.
        if vim.opt_local.modifiable:get() then
          lint.try_lint()
        end
      end,
    })

    -- add LinterInfo to display active linters
    vim.api.nvim_create_user_command('LinterInfo', function()
      local runningLinters = table.concat(require('lint').linters_by_ft[vim.bo.filetype] or {}, '\n')
      vim.notify(runningLinters, vim.log.levels.INFO, { title = 'nvim-lint' })
    end, {})

    -- add LinterRunning to show active running linters
    vim.api.nvim_create_user_command('LinterRunning', function()
      local runningLinters = table.concat(require('lint').get_running() or {}, '\n')
      vim.notify(runningLinters, vim.log.levels.INFO, { title = 'nvim-lint' })
    end, {})
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
