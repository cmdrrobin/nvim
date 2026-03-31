local M = {}

local icons = require('icons')

-- Don't show the command that produced the quickfix list.
vim.g.qf_disable_statusline = 1

-- colors from rose-pine palette
-- https://rosepinetheme.com/palette/
---@type table<string, string>
local colors = {
  base = '#191724',
  surface = '#1f1d2e',
  overlay = '#26233a',
  muted = '#6e6a86',
  subtle = '#908caa',
  text = '#e0def4',
  love = '#eb6f92',
  gold = '#f6c177',
  rose = '#ebbcba',
  pine = '#31748f',
  foam = '#9ccfd8',
  iris = '#c4a7e7',
  leaf = '#95b1ac',
  highlight_low = '#21202e',
  highlight_med = '#403d52',
  highlight_high = '#524f67',
  none = 'NONE',
}
--- Keeps track of the highlight groups
---@type table<string, table>
local statusline_hls = {}

for mode, hl in pairs({
  Normal = { bg = colors.rose, fg = colors.base, bold = true },
  Insert = { bg = colors.foam, fg = colors.base, bold = true },
  Visual = { bg = colors.iris, fg = colors.base, bold = true },
  Replace = { bg = colors.pine, fg = colors.base, bold = true },
  Command = { bg = colors.love, fg = colors.base, bold = true },
  Inactive = { bg = colors.surface, fg = colors.base, bold = true },
}) do
  statusline_hls['StatuslineMode' .. mode] = hl
end
statusline_hls = vim.tbl_extend('error', statusline_hls, {
  StatuslineItalic = { fg = colors.muted, bg = colors.surface, italic = true },
  StatuslineSpinner = { fg = colors.foam, bg = colors.surface, bold = true },
  StatuslineTitle = { fg = colors.subtle, bg = colors.surface, bold = true },
  StatuslineInfo = { fg = colors.iris, bg = colors.surface },
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

-- Detect if the current working directory is a Jujutsu repository
---@return boolean
function M.is_jj()
  local is_jj_exec = vim.fn.executable('jj') == 1
  local is_jj_repo = vim.fn.isdirectory(vim.fn.getcwd() .. '/.jj') == 1
  return is_jj_exec and is_jj_repo
end

---@type nil|string
local _cache = nil -- last computed status string
---@type boolean
local _dirty = true -- true = needs a refresh on next render

-- Invalidate whenever the user writes a buffer or enters a new buffer
-- (switching projects may change the jj context entirely).
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('jj_status_cache', { clear = true }),
  callback = function()
    _dirty = true
  end,
})

-- Get the closest bookmark reachable from @-, or fall back to the short change ID of @
---@return nil|string
function M.jj_status()
  if not _dirty and _cache ~= nil then
    return _cache
  end

  -- `closest_bookmark(@-)` finds the nearest ancestor commit that has a bookmark.
  -- The `bookmarks` template outputs names directly, e.g. "main*" (* = has local changes).
  local name = vim.fn.system('jj log -r "closest_bookmark(@-)" --no-pager --no-graph --ignore-working-copy -T "bookmarks" 2>/dev/null')
  name = name:gsub('%*', ''):gsub('%s+', '')
  if name ~= '' then
    _cache = name
    _dirty = false
    return _cache
  end

  -- No bookmark found: show the short change ID of the working-copy commit
  local id = vim.fn.system('jj log -r @ --no-graph -T "change_id.short()" --no-pager --ignore-working-copy 2>/dev/null')
  _cache = id:gsub('%s+', '')
  _dirty = false
  return _cache
end

---@return string
function M.jj_component()
  return icons.misc.Bookmark .. ' ' .. M.jj_status()
end

---@return string
function M.git_component()
  local git_info = vim.b.gitsigns_status_dict

  if not git_info or git_info.head == '' then
    return ''
  end
  local git_head = icons.git.branch .. ' ' .. git_info.head

  local added = (git_info.added and git_info.added ~= 0) and ('%#GitSignsAdd#+' .. git_info.added) or ''
  local changed = (git_info.changed and git_info.changed ~= 0) and (' %#GitSignsChange#~' .. git_info.changed) or ''
  local removed = (git_info.removed and git_info.removed ~= 0) and (' %#GitSignsDelete#-' .. git_info.removed) or ''

  local branch = M.is_jj() and M.jj_component() or git_head
  return '%#StatuslineInfo#' .. branch .. '%#Statusline# ' .. added .. changed .. removed .. '%#Statusline#'
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

---@type table<string>
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
    return '%#StatuslineSpinner#' .. spinner_symbols[spinner_index] .. '%#StatuslineTitle# ' .. progress_status.client .. '%#Statusline#'
  end
  return string.format('%%#StatuslineTitle#%s  ', progress_status.client)
end

---@return string
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

  -- Get mode highlight
  local mode = modes[vim.api.nvim_get_mode().mode] or 'UNKNOWN'
  local hl_suffix = mode_hls[mode] or 'Other'
  local mode_hl = 'StatuslineMode' .. hl_suffix

  local lines_output = string.format('%%#StatuslineItalic#l: %%#StatuslineTitle#%3d%%#StatuslineItalic#/%d', line, line_count)
  local col_output = string.format('c: %-3d', col)
  local post_output = string.format('%%#%s# %%P ', mode_hl)

  return lines_output .. ' ' .. col_output .. ' ' .. post_output
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

---@return string
function M.apply_icon()
  local icon, hl_group
  local ok, devicons = pcall(require, 'nvim-web-devicons')

  if ok then
    icon, hl_group = devicons.get_icon(vim.fn.expand('%:t'))
    if not icon then
      icon, hl_group = devicons.get_icon_by_filetype(vim.bo.filetype)
    end
  end

  -- Default fallback
  if not icon then
    icon = ' '
    hl_group = 'DevIconDefault'
  end

  -- Return with highlight group applied
  if hl_group then
    return string.format('%%#%s#%s %%#Statusline#', hl_group, icon)
  end
  return icon .. ' '
end

---@return string
function M.filetype_component()
  return M.apply_icon() .. vim.bo.filetype
end

function M.filename_component()
  return '%<%f%m%r'
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
      M.filename_component(),
    }),
    '%=', -- align to right
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
