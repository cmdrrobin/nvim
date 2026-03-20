-- List of formatters and/or linters that need to be installed
---@type table<string>
local ensure_installed = {
  'stylua',
  'shfmt',
  'goimports',
  'gofumpt',
  'hadolint',
  'markdownlint-cli2',
  'ansible-lint',
  'prettier',
}

vim.pack.add({
  { src = 'https://github.com/mason-org/mason.nvim', data = { build = 'MasonUpdate' } },
}, { confirm = false })

require('mason').setup()

local mr = require('mason-registry')
mr:on('package:install:success', function()
  vim.defer_fn(function()
    -- trigger FileType event to possibly load this newly installed LSP server or linter
    vim.api.nvim_exec_autocmds('FileType', {
      buffer = vim.api.nvim_get_current_buf(),
    })
  end, 100)
end)

mr.refresh(function()
  for _, tool in ipairs(ensure_installed) do
    local pkg = mr.get_package(tool)
    if not pkg:is_installed() then
      pkg:install()
    end
  end
end)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
