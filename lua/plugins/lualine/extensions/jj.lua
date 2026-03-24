---@module "lualine"

local M = {}

local icons = require('icons')

-- Detect if the current working directory is a Jujutsu repository
local function is_jj_repo()
  return vim.fn.isdirectory(vim.fn.getcwd() .. '/.jj') == 1
end

-- Get the closest bookmark reachable from @-, or fall back to the short change ID of @
local function jj_status()
  -- `closest_bookmark(@-)` finds the nearest ancestor commit that has a bookmark.
  -- The `bookmarks` template outputs names directly, e.g. "main*" (* = has local changes).
  local name = vim.fn.system('jj log -r "closest_bookmark(@-)" --no-pager --no-graph --ignore-working-copy -T "bookmarks" 2>/dev/null')
  name = name:gsub('%*', ''):gsub('%s+', '')
  if name ~= '' then
    return name
  end
  -- No bookmark found: show the short change ID of the working-copy commit
  local id = vim.fn.system('jj log -r @ --no-graph -T "change_id.short()" --no-pager --ignore-working-copy 2>/dev/null')
  return id:gsub('%s+', '')
end

-- Lualine component: shown in place of 'branch' when inside a jj repo
M.component = {
  function()
    return jj_status()
  end,
  icon = vim.g.have_icons and icons.git.branch or nil,
  cond = is_jj_repo,
}

M.is_jj_repo = is_jj_repo()

return M

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
