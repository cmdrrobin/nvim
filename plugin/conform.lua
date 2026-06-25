-- Define formatting based on filetype
local formatters_by_ft = {
  dockerfile = { 'hadolint' },
  go = { 'goimports', 'gofumpt' },
  lua = { 'stylua' },
  python = { 'ruff' },
  terraform = { 'terraform_fmt' },
  tf = { 'terraform_fmt' },
  ['terraform-vars'] = { 'terraform_fmt' },
  yaml = { 'yamlfmt' },
  -- For filetypes without a formatter
  ['_'] = { 'trim_whitespace', 'trim_newlines' },
}
-- Define formatting based on filetype
local formatters_by_ft = {
  dockerfile = { 'hadolint' },
  go = { 'goimports', 'gofumpt' },
  lua = { 'stylua' },
  python = { 'ruff' },
  terraform = { 'terraform_fmt' },
  tf = { 'terraform_fmt' },
  ['terraform-vars'] = { 'terraform_fmt' },
  yaml = { 'prettier' },
  -- For filetypes without a formatter
  ['_'] = { 'trim_whitespace', 'trim_newlines' },
}
local add_on_event = require('vim-pack').add_on_event

-- Disable "format_on_save lsp_fallback" for languages that don't
-- have a well standardized coding style.
local disable_filetypes = { c = true, cpp = true }

add_on_event('BufWritePre', {
  {
    src = 'https://github.com/stevearc/conform.nvim',
    opts = {
      -- Define formatting based on filetype
      formatters_by_ft = {
        dockerfile = { 'hadolint' },
        go = { 'goimports', 'gofumpt' },
        lua = { 'stylua' },
        python = { 'ruff' },
        terraform = { 'terraform_fmt' },
        tf = { 'terraform_fmt' },
        ['terraform-vars'] = { 'terraform_fmt' },
        yaml = { 'prettier' },
        -- For filetypes without a formatter
        ['_'] = { 'trim_whitespace', 'trim_newlines' },
      },
      notify_on_error = false,
      format_on_save = function(bufnr)
        local lsp_format_opt
        -- Do not format on save when disable_autoformat is set globally or for buffer
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end

        return {
          timeout_ms = 2000,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters = {
        -- Require a Prettier configuration file to format.
        prettier = { require_cwd = true },
      },
    },
  },
})

vim.api.nvim_create_user_command('ToggleFormat', function(opts)
  if opts.bang then
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    vim.notify(string.format('%s formatting (buffer)...', vim.b.disable_autoformat and 'Disabling' or 'Enabling'), vim.log.levels.INFO)
  else
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    vim.notify(string.format('%s formatting (globally)...', vim.g.disable_autoformat and 'Disabling' or 'Enabling'), vim.log.levels.INFO)
  end
end, { desc = 'Toggle autoformat on save', bang = true })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
