---@module 'lazy'

-- Load Codecompanion extension locally
local codecompanion = require('plugins.lualine.extensions.codecompanion')

---@type LazySpec
return {
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    event = 'UIEnter',
    -- See `:help lualine.txt`
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = ' '
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local icons = require('icons')

      vim.o.laststatus = vim.g.lualine_laststatus

      local filename = {
        'filename',
        path = 1, -- display relative path
        shorting_target = 40,
      }

      local lsp_status = {
        'lsp_status',
        color = 'StatusLineNC',
      }

      -- show number of spaces that is used for current buffer with additional icon
      local spaces = {
        function()
          if not vim.g.have_icons then
            return vim.api.nvim_get_option_value('shiftwidth', { buf = 0 })
          else
            return icons.misc.Spaces .. ' ' .. vim.api.nvim_get_option_value('shiftwidth', { buf = 0 })
          end
        end,
      }

      return {
        options = {
          icons_enabled = vim.g.have_icons,
          theme = 'auto',
          globalstatus = vim.o.laststatus == 3,
          component_separators = { left = '|', right = '' },
          section_separators = '',
          disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'snacks_dashboard' } },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { filename },
          lualine_x = { lsp_status, spaces, 'filetype' },
          lualine_y = { 'location' },
          lualine_z = { 'progress' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { filename },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { codecompanion, 'fugitive', 'lazy', 'nvim-dap-ui', 'trouble', 'mason', 'oil', 'quickfix' },
      }
    end,
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
