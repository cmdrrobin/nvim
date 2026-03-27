local M = {}

-- Use default statusline when rose-pine is not available
local palette_ok, p = pcall(require, 'rose-pine.palette')
if not palette_ok then
  return
end

local icons = require('icons')

-- Don't show the command that produced the quickfix list.
vim.g.qf_disable_statusline = 1

-- Show the mode in my custom component instead.
vim.o.showmode = false

--- Keeps track of the highlight groups
---@type table<string, table>
local statusline_hls = {}

for mode, hl in pairs({
  Normal = { bg = p.rose, fg = p.base, bold = true },
  Insert = { bg = p.foam, fg = p.base, bold = true },
  Visual = { bg = p.iris, fg = p.base, bold = true },
  Replace = { bg = p.pine, fg = p.base, bold = true },
  Command = { bg = p.love, fg = p.base, bold = true },
  Inactive = { bg = p.surface, fg = p.muted, bold = true },
}) do
  statusline_hls['StatuslineMode' .. mode] = hl
end
statusline_hls = vim.tbl_extend('error', statusline_hls, {
  StatuslineItalic = { fg = p.muted, bg = p.surface, italic = true },
  StatuslineSpinner = { fg = p.foam, bg = p.surface, bold = true },
  StatuslineTitle = { fg = p.muted, bg = p.surface, bold = true },
})

for group, opts in pairs(statusline_hls) do
  vim.api.nvim_set_hl(0, group, opts)
end

--- Mode string lookup table (module-level to avoid recreation on every render)
---@type table<string, string>
local modes = {
  ['n'] = 'NORMAL',
  ['no'] = 'O-PENDING',
  ['nov'] = 'O-PENDING',
  ['noV'] = 'O-PENDING',
  ['no\22'] = 'O-PENDING',
  ['niI'] = 'NORMAL',
  ['niR'] = 'NORMAL',
  ['niV'] = 'NORMAL',
  ['nt'] = 'NORMAL',
  ['ntT'] = 'NORMAL',
  ['v'] = 'VISUAL',
  ['vs'] = 'VISUAL',
  ['V'] = 'V-LINE',
  ['Vs'] = 'V-LINE',
  ['\22'] = 'V-BLOCK',
  ['\22s'] = 'V-BLOCK',
  ['s'] = 'SELECT',
  ['S'] = 'S-LINE',
  ['\19'] = 'S-BLOCK',
  ['i'] = 'INSERT',
  ['ic'] = 'INSERT',
  ['ix'] = 'INSERT',
  ['R'] = 'REPLACE',
  ['Rc'] = 'REPLACE',
  ['Rx'] = 'REPLACE',
  ['Rv'] = 'V-REPLACE',
  ['Rvc'] = 'V-REPLACE',
  ['Rvx'] = 'V-REPLACE',
  ['c'] = 'COMMAND',
  ['cv'] = 'EX',
  ['ce'] = 'EX',
  ['r'] = 'REPLACE',
  ['rm'] = 'MORE',
  ['r?'] = 'CONFIRM',
  ['!'] = 'SHELL',
  ['t'] = 'TERMINAL',
}

--- Lookup table mapping mode strings to highlight group suffixes
---@type table<string, string>
local mode_hls = {
  NORMAL = 'Normal',
  ['O-PENDING'] = 'Normal',
  VISUAL = 'Visual',
  ['V-LINE'] = 'Visual',
  ['V-BLOCK'] = 'Visual',
  INSERT = 'Insert',
  SELECT = 'Insert',
  ['S-LINE'] = 'Insert',
  ['S-BLOCK'] = 'Insert',
  REPLACE = 'Replace',
  ['V-REPLACE'] = 'Replace',
  COMMAND = 'Command',
  EX = 'Command',
  TERMINAL = 'Command',
  SHELL = 'Command',
}

--- Current mode.
---@return string
function M.mode_component()
  local mode = modes[vim.api.nvim_get_mode().mode] or 'UNKNOWN'
  local hl = mode_hls[mode] or 'Other'
  return string.format('%%#StatuslineMode%s# %s %%#Statusline#', hl, mode)
end

---@return string
function M.git_component()
  local git_info = vim.b.gitsigns_status_dict

  if not git_info or git_info.head == '' then
    return ''
  end

  local added = (git_info.added and git_info.added ~= 0) and ('%#GitSignsAdd#+' .. git_info.added .. ' ') or ''
  local changed = (git_info.changed and git_info.changed ~= 0) and ('%#GitSignsChange#~' .. git_info.changed .. ' ') or ''
  local removed = (git_info.removed and git_info.removed ~= 0) and ('%#GitSignsDelete#-' .. git_info.removed .. ' ') or ''

  return '%#GitSignsAdd# ' .. git_info.head .. ' %#Normal# ' .. added .. changed .. removed .. '%#Statusline#'
end

---@type table<string, string?>
local progress_status = {
  client = nil,
  kind = nil,
  title = nil,
}

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

vim.api.nvim_create_autocmd('LspProgress', {
  group = vim.api.nvim_create_augroup('cmdrrobin/statusline', { clear = true }),
  desc = 'Update LSP progress in statusline',
  pattern = { 'begin', 'end' },
  callback = function(args)
    -- This should in theory never happen, but I've seen weird errors.
    if not args.data then
      return
    end

    progress_status = {
      client = vim.lsp.get_client_by_id(args.data.client_id).name,
      kind = args.data.params.value.kind,
      title = args.data.params.value.title,
    }

    if progress_status.kind == 'end' then
      progress_status.title = nil
      processing = false
      -- Stop timer
      if spinner_timer then
        spinner_timer:stop()
        spinner_timer:close()
        spinner_timer = nil
      end
      -- Wait a bit before clearing the status.
      vim.defer_fn(function()
        vim.cmd.redrawstatus()
      end, 1000)
    else
      processing = true
      -- Start timer to update statusline every 100ms
      if not spinner_timer then
        spinner_timer = vim.uv.new_timer()
        if spinner_timer then
          spinner_timer:start(0, 100, function()
            vim.schedule(function()
              vim.cmd.redrawstatus()
            end)
          end)
        end
      end
    end
  end,
})

--- The latest LSP progress message.
---@return string
function M.lsp_progress_component()
  if not progress_status.client or not progress_status.title then
    return ''
  end

  -- Avoid noisy messages while typing.
  if vim.startswith(vim.api.nvim_get_mode().mode, 'i') then
    return ''
  end

  if processing then
    spinner_index = (spinner_index % #spinner_symbols) + 1
    return '%#StatuslineSpinner#' .. spinner_symbols[spinner_index] .. '%#StatuslineTitle# ' .. progress_status.client
  end
  return string.format('%%#StatuslineTitle#%s  ', progress_status.client)
end

function M.diagnostics_component()
  return vim.diagnostic.status()
end

--- File-content encoding for the current buffer.
---@return string
function M.encoding_component()
  local encoding = vim.opt.fileencoding:get()
  return encoding ~= '' and string.format('%%#StatuslineModeSeparatorOther# %s', encoding) or ''
end

--- The current line, total line count, and column position.
---@return string
function M.position_component()
  local line = vim.fn.line('.')
  local line_count = vim.api.nvim_buf_line_count(0)
  local col = vim.fn.virtcol('.')

  return string.format('%%#StatuslineItalic#l: %%#StatuslineTitle#%3d%%#StatuslineItalic#/%d c: %3d %%P ', line, line_count, col)
end

--- Number of spaces used for indentation in the current buffer.
---@return string
function M.spaces_component()
  local sw = vim.bo.shiftwidth
  if not vim.g.have_icons then
    return tostring(sw)
  end
  return icons.misc.Spaces .. ' ' .. sw
end

function M.filetype_component()
  return string.format(' %s ', vim.bo.filetype):upper()
end

--- Joins non-empty components with two spaces.
---@param components string[]
---@return string
local function concat_components(components)
  return vim.iter(components):skip(1):fold(components[1], function(acc, component)
    return #component > 0 and string.format('%s  %s', acc, component) or acc
  end)
end

--- Renders the statusline.
---@return string
function M.render()
  return table.concat({
    concat_components({
      M.mode_component(),
      M.git_component(),
      M.diagnostics_component(),
      '%< %f',
    }),
    '%#StatusLine#%=',
    concat_components({
      M.lsp_progress_component(),
      M.spaces_component(),
      M.filetype_component(),
      M.position_component(),
    }),
  })
end

vim.o.statusline = "%!v:lua.require'statusline'.render()"

return M
