local M = {}

-- Path definition to extras and preferences
-- preferences_path is used for saving enabled extras
local extras_path = vim.fn.stdpath('config') .. '/lua/extras'
local preferences_path = vim.fn.stdpath('data') .. '/extras_preferences.json'

-- Get all available extras
---@return table
function M.get_available_extras()
  local extras = {}

  -- Helper function to scan directories recursively
  ---@param dir string
  ---@param prefix string?
  local function scan_directory(dir, prefix)
    prefix = prefix or ''
    local files = vim.fn.glob(dir .. '/*', false, true)

    for _, file in ipairs(files) do
      local name = vim.fn.fnamemodify(file, ':t:r')
      local is_directory = vim.fn.isdirectory(file) == 1
      local rel_path = prefix .. (prefix ~= '' and '.' or '') .. name

      if is_directory then
        -- Recursively scan subdirectories
        scan_directory(file, rel_path)
      elseif vim.fn.fnamemodify(file, ':e') == 'lua' then
        table.insert(extras, { name = name, path = rel_path, full_path = file })
      end
    end
  end

  scan_directory(extras_path)
  return extras
end

-- Load/save preferences
---@return table
function M.load_preferences()
  if vim.fn.filereadable(preferences_path) ~= 1 then
    return {}
  end

  local content = vim.fn.readfile(preferences_path)
  local ok, parsed = pcall(vim.json.decode, table.concat(content))
  return ok and parsed or {}
end

-- function for writing enabled extras to preferences path file
---@param preferences any
function M.save_preferences(preferences)
  local content = vim.json.encode(preferences)
  vim.fn.mkdir(vim.fn.fnamemodify(preferences_path, ':h'), 'p')
  vim.fn.writefile({ content }, preferences_path)
end

-- Get specs for enabled extras
---@return table
function M.get_enabled_extras_spec()
  local preferences = M.load_preferences()
  local specs = {}

  for _, extra in ipairs(M.get_available_extras()) do
    if preferences[extra.path] then
      table.insert(specs, { import = 'extras.' .. extra.path, optional = true })
    end
  end

  return specs
end

-- UI for managing extras
function M.open_extras_ui()
  local available = M.get_available_extras()
  local preferences = M.load_preferences()

  local items = {}
  for _, extra in ipairs(available) do
    table.insert(items, {
      name = extra.name,
      path = extra.path,
      full_path = extra.full_path,
      enabled = preferences[extra.path] == true,
    })
  end

  local formatted_items = {}
  for _, item in ipairs(items) do
    table.insert(formatted_items, (item.enabled and '[x] ' or '[ ] ') .. item.path)
  end

  -- Use snacks if available, otherwise fallback to vim.ui.select
  if pcall(require, 'snacks') then
    local snacks = require('snacks')

    snacks.picker.select(formatted_items, {
      prompt = 'Select extras to toggle:',
    }, function(choice, idx)
      if not choice then
        return
      end

      local path = items[idx].path
      preferences[path] = not items[idx].enabled
      M.save_preferences(preferences)

      vim.notify('Extras preferences saved. Restart Neovim to apply changes.', vim.log.levels.INFO)
    end)
  else
    vim.ui.select(formatted_items, {
      prompt = 'Select extras to toggle:',
    }, function(choice, idx)
      if not choice then
        return
      end

      local path = items[idx].path
      preferences[path] = not items[idx].enabled
      M.save_preferences(preferences)

      vim.notify('Extras preferences saved. Restart Neovim to apply changes.', vim.log.levels.INFO)
    end)
  end
end

-- User command for entering extras UI
vim.api.nvim_create_user_command('Extras', function()
  M.open_extras_ui()
end, { desc = 'Extras UI for toggling extras plugins', nargs = 0 })

return M
