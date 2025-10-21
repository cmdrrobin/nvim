---@module "lualine"

local M = {}

-- Some default values for process and spinner icons
local processing = false
local spinner_index = 1
local spinner_timer = nil

local spinner_symbols = {
  '⠋',
  '⠙',
  '⠹',
  '⠸',
  '⠼',
  '⠴',
  '⠦',
  '⠧',
  '⠇',
  '⠏',
}

local icons = require('icons')

-- Capture starting and ending of processing by Code Companion
vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = 'CodeCompanionRequest*',
  group = vim.api.nvim_create_augroup('CodeCompanionHooks', {}),
  callback = function(ev)
    if ev.match == 'CodeCompanionRequestStarted' then
      processing = true
      -- Start timer to update statusline every 100ms
      spinner_timer = vim.uv.new_timer()
      if spinner_timer then
        spinner_timer:start(0, 100, function()
          vim.schedule(function()
            vim.cmd('redrawstatus')
          end)
        end)
      end
    elseif ev.match == 'CodeCompanionRequestFinished' then
      processing = false
      -- Stop timer
      if spinner_timer then
        spinner_timer:stop()
        spinner_timer:close()
        spinner_timer = nil
      end
    end
  end,
})

-- Use Copilot icon or spinning dots, depending on processing state
local function CodeCompanionProgress()
  if processing then
    spinner_index = (spinner_index % #spinner_symbols) + 1
    return spinner_symbols[spinner_index] .. ' '
  end

  return icons.kind.Copilot
end

-- Set buffer name
local function BufferName()
  return 'CodeCompanion'
end

M.sections = {
  lualine_a = { 'mode' },
  lualine_c = { BufferName },
  lualine_x = { CodeCompanionProgress },
  lualine_y = {},
  lualine_z = {},
}

M.filetypes = { 'codecompanion' }

return M
