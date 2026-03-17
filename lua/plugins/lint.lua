vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    vim.pack.add({ 'https://github.com/mfussenegger/nvim-lint' })

    local lint = require('lint')

    lint.linters_by_ft = {
      markdown = { 'markdownlint-cli2' },
      ansible = { 'ansible-lint' },
    }

    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        -- Only run the linter in buffers that you can modify in order to
        -- avoid superfluous noise, notably within the handy LSP pop-ups that
        -- describe the hovered symbol using Markdown.
        if vim.bo.modifiable then
          lint.try_lint()
        end
      end,
    })
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
