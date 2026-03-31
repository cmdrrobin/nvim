-- Make it possible to format manually
vim.api.nvim_create_user_command('Format', function()
  local conform_ok, conform = pcall(require, 'conform')
  if conform_ok then
    conform.format({ async = true, lsp_fallback = true })
  else
    vim.lsp.buf.format()
  end
end, { desc = 'Format current buffer', nargs = 0 })

vim.api.nvim_create_user_command('GoToFile', 'lua Snacks.picker.smart()', { desc = 'Open smart file picker', nargs = 0 })
vim.api.nvim_create_user_command('GoToNotes', 'ObsidianSearch', { desc = 'Search Obsidian notes', nargs = 0 })

-- Get _all_ packages that are currently installed and available
local function complete_packages()
  return vim
    .iter(vim.pack.get())
    :map(function(pack)
      return pack.spec.name
    end)
    :totable()
end

-- Get all inactive packages that are currently available
local function inactive_packages()
  return vim
    .iter(vim.pack.get())
    :filter(function(pack)
      return not pack.active
    end)
    :map(function(pack)
      return pack.spec.name
    end)
    :totable()
end

vim.api.nvim_create_user_command('PackList', function()
  vim.pack.update(nil, { offline = true })
end, { desc = 'List Packages', nargs = 0 })

vim.api.nvim_create_user_command('PackUpdate', function(info)
  if #info.fargs ~= 0 then
    vim.pack.update(info.fargs, { force = info.bang })
  else
    vim.pack.update(nil, { force = info.bang })
  end
end, {
  desc = 'Update package(s)',
  nargs = '*',
  bang = true,
  complete = complete_packages,
})

vim.api.nvim_create_user_command('PackSync', function(info)
  if #info.fargs ~= 0 then
    vim.pack.update(info.fargs, { target = 'lockfile', force = info.bang })
  else
    vim.pack.update(nil, { target = 'lockfile', force = info.bang })
  end
end, {
  desc = 'Sync package(s) with lockfile',
  nargs = '*',
  bang = true,
  complete = complete_packages,
})

vim.api.nvim_create_user_command('PackDelete', function(info)
  vim.pack.del(info.fargs, { force = info.bang })
end, {
  desc = 'Delete inactive package(s)',
  nargs = '+',
  bang = true,
  complete = inactive_packages,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
