---@module 'lazy'
---@type LazySpec
return {
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    ---@module 'gitsigns.config'
    ---@type Gitsigns.Config
    ---@diagnostic disable: missing-fields
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        -- stylua: ignore start
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({']c', bang = true})
          else
            gs.nav_hunk('next')
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({'[c', bang = true})
          else
            gs.nav_hunk('prev')
          end
        end, { desc = 'Jump to previous git [c]hange' })

        vim.keymap.set('n', '<leader>hs', require('gitsigns').stage_hunk, { buffer = bufnr, desc = 'Stage Hunk' })
        vim.keymap.set('n', '<leader>hr', require('gitsigns').reset_hunk, { buffer = bufnr, desc = 'Reset Hunk' })
        vim.keymap.set('n', '<leader>hS', require('gitsigns').stage_buffer, { buffer = bufnr, desc = 'Stage Buffer' })
        vim.keymap.set('n', '<leader>hu', require('gitsigns').stage_hunk, { buffer = bufnr, desc = 'Undo Stage Hunk' })
        vim.keymap.set('n', '<leader>hR', require('gitsigns').reset_buffer, { buffer = bufnr, desc = 'Reset Buffer' })
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview Hunk' })
        vim.keymap.set('n', '<leader>hb', require('gitsigns').blame_line, { buffer = bufnr, desc = 'Blame Line' })
        vim.keymap.set('n', '<leader>tb', require('gitsigns').toggle_current_line_blame, { buffer = bufnr, desc = 'Toggle Line Blame' })
        vim.keymap.set('n', '<leader>hd', require('gitsigns').diffthis, { buffer = bufnr, desc = 'Diff This' })
        vim.keymap.set('n', '<leader>td', require('gitsigns').preview_hunk_inline, { buffer = bufnr, desc = 'Toggle Deleted' })
        -- stylua: ignore start
      end,
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
