-- Define linters based on filetype
local linters_by_ft = {
  markdown = { 'markdownlint-cli2' },
  ansible = { 'ansible_lint' },
}

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    vim.pack.add({ 'https://github.com/mfussenegger/nvim-lint' })

    local lint = require('lint')

    lint.linters_by_ft = linters_by_ft

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('lint', { clear = true }),
      callback = function()
        -- Only run the linter in buffers that you can modify in order to
        -- avoid superfluous noise, notably within the handy LSP pop-ups that
        -- describe the hovered symbol using Markdown.
        if vim.bo.modifiable then
          lint.try_lint()
        end
      end,
    })

    -- add LinterInfo to display active linters
    vim.api.nvim_create_user_command('LinterInfo', function()
      local runningLinters = table.concat(require('lint').linters_by_ft[vim.bo.filetype] or {}, '\n')
      if runningLinters == '' then
        runningLinters = 'No linters available'
      end
      vim.notify(runningLinters, vim.log.levels.INFO, { title = 'nvim-lint' })
    end, {})

    -- add LinterRunning to show active running linters
    vim.api.nvim_create_user_command('LinterRunning', function()
      local runningLinters = table.concat(require('lint').get_running() or {}, '\n')
      if runningLinters == '' then
        runningLinters = 'No running linters'
      end
      vim.notify(runningLinters, vim.log.levels.INFO, { title = 'nvim-lint' })
    end, {})
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
