-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = false
  end,
})

-- Allow using q key to quit buffer for some filytypes
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'qf', 'help', 'man', 'netrw', 'lspinfo', 'fugitive', 'git' },
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true })
    vim.opt_local.buflisted = false
  end,
})

-- Add project name to titlebar of terminal
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = { '' },
  callback = function()
    local get_project_dir = function()
      local cwd = vim.fn.getcwd() or ''
      local project_dir = vim.split(cwd, '/')
      local project_name = project_dir[#project_dir]
      return project_name
    end

    vim.opt.titlestring = get_project_dir()
  end,
})

-- Make it possible to format manually
vim.api.nvim_create_user_command('Format', function()
  local conform_ok, conform = pcall(require, 'conform')
  if conform_ok then
    conform.format({ async = true, lsp_fallback = true })
  else
    vim.lsp.buf.format()
  end
end, { desc = 'Format current buffer' })

-- Make it possible to toggle auto formatting
vim.api.nvim_create_user_command('FormatToggle', function()
  vim.g.format_on_save = not vim.g.format_on_save
end, { desc = 'Toggle format on save' })

-- When using terminal, remove (relative) numbers
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('cust-term-open', { clear = true }),
  callback = function()
    vim.o.number = false
    vim.o.relativenumber = false
  end,
})
