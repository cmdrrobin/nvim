-- List of formatters and/or linters that need to be installed
---@type table<string>
local ensure_installed = {
  'ansible-language-server',
  'ansible-lint',
  'bash-language-server',
  'docker-compose-language-service',
  'dockerfile-language-server',
  'gofumpt',
  'goimports',
  'gopls',
  'hadolint',
  'json-lsp',
  'lua-language-server',
  'markdownlint-cli2',
  'prettier',
  'ruff',
  'shfmt',
  'stylua',
  'stylua',
  'taplo',
  'terraform-ls',
  'ty',
  'typescript-language-server',
  'yaml-language-server',
}

vim.pack.add({
  { src = 'https://github.com/mason-org/mason.nvim', data = { build = 'MasonUpdate' } },
}, { confirm = false })

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
  once = true,
  callback = function()
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
  end,
})

-- Open a Snacks picker to select and enable a Mason-installed LSP server
local function pick_and_enable_lsp()
  local ok, mr = pcall(require, 'mason-registry')
  if not ok then
    vim.notify('mason-registry is not available', vim.log.levels.ERROR)
    return
  end

  local items = {}
  for _, pkg in ipairs(mr.get_installed_packages()) do
    local spec = pkg.spec
    local lsp_name = vim.tbl_get(spec, 'neovim', 'lspconfig')
    if lsp_name then
      local is_active = #vim.lsp.get_clients({ name = lsp_name }) > 0

      table.insert(items, {
        text = lsp_name,
        lsp_name = lsp_name,
        mason_name = pkg.name,
        is_active = is_active,
      })
    end
  end

  table.sort(items, function(a, b)
    return a.lsp_name < b.lsp_name
  end)

  if #items == 0 then
    vim.notify('No LSP servers installed via Mason', vim.log.levels.WARN)
    return
  end

  require('snacks').picker.pick({
    title = 'Enable LSP Server',
    items = items,
    format = function(item)
      local ret = { { item.lsp_name, 'SnacksPickerLabel' } }
      if item.mason_name ~= item.lsp_name then
        table.insert(ret, { '  ' .. item.mason_name, 'Comment' })
      end
      if item.is_active then
        table.insert(ret, { '  active', 'DiagnosticOk' })
      end
      return ret
    end,
    layout = { preset = 'vertical', preview = false },
    confirm = function(picker, item)
      picker:close()
      if item then
        vim.schedule(function()
          vim.lsp.enable(item.lsp_name)
          vim.notify('LSP enabled: ' .. item.lsp_name, vim.log.levels.INFO)
        end)
      end
    end,
  })
end

vim.api.nvim_create_user_command('MasonEnableLSP', pick_and_enable_lsp, {
  desc = 'Pick and enable a Mason-installed LSP server',
})

vim.keymap.set('n', '<leader>ml', pick_and_enable_lsp, { desc = '[M]ason enable [L]SP' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
