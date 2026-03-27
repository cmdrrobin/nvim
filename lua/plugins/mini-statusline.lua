vim.pack.add({ 'https://github.com/nvim-mini/mini.statusline' })

local ministatus = require('mini.statusline')

ministatus.setup({
  content = {
    active = function()
      -- Just show current line and column
      local section_location = function()
        return '%l:%v'
      end

      local icons = require('icons')

      -- show number of spaces that is used for current buffer with additional icon
      local spaces = function()
        if not vim.g.have_icons then
          return vim.api.nvim_get_option_value('shiftwidth', { buf = 0 })
        else
          return icons.misc.Spaces .. ' ' .. vim.api.nvim_get_option_value('shiftwidth', { buf = 0 })
        end
      end

      local function git_status()
        local git_info = vim.b.gitsigns_status_dict
        if not git_info or git_info.head == '' then
          return ''
        end

        local head = git_info.head
        local added = git_info.added and (' +' .. git_info.added) or ''
        local changed = git_info.changed and (' ~' .. git_info.changed) or ''
        local removed = git_info.removed and (' -' .. git_info.removed) or ''
        if git_info.added == 0 then
          added = ''
        end
        if git_info.changed == 0 then
          changed = ''
        end
        if git_info.removed == 0 then
          removed = ''
        end

        return table.concat({
          '[ ', -- branch icon
          head,
          added,
          changed,
          removed,
          ']',
        })
      end

      local mode, mode_hl = ministatus.section_mode({ trunc_width = 120 })
      local git = MiniStatusline.section_git({ trunc_width = 40 })
      local diff = MiniStatusline.section_diff({ trunc_width = 75 })
      local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
      local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

      return MiniStatusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { git_status(), diff, diagnostics } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        { strings = { spaces() } },
        { hl = 'MiniStatuslineFileinfo', strings = { vim.bo.filetype } },
        { strings = { search, '%l:%v' } },
        { hl = mode_hl, strings = { '%P' } },
      })
    end,
  },
})
