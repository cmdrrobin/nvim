local add = require('vim-pack').add
local on_plugin_update = require('vim-pack').on_plugin_update

local ensure_installed = {
  'bash',
  'c',
  'diff',
  'gitcommit',
  'go',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'regex',
  'query',
  'terraform',
  'toml',
  'vim',
  'vimdoc',
}

add({
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    on_setup = function()
      -- Main-branch nvim-treesitter ships queries under `runtime/queries/`,
      -- which isn't on rtp by default. Prepend it so highlights/folds/indents
      -- are visible to `vim.treesitter.start`.
      local init = vim.api.nvim_get_runtime_file('lua/nvim-treesitter/init.lua', false)[1]
      if init then
        vim.opt.runtimepath:prepend(vim.fn.fnamemodify(init, ':h:h:h') .. '/runtime')
      end

      require('nvim-treesitter').install(ensure_installed):wait(300000)
    end,
  },
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter-context',
    name = 'treesitter-context',
    opts = {
      -- Avoid the sticky context from growing a lot.
      max_lines = 3,
      -- Match the context lines to the source code.
      multiline_threshold = 1,
      -- Disable it when the window is too small.
      min_window_height = 20,
    },
  },
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    on_setup = function()
      -- SELECT keymaps
      local sel = require('nvim-treesitter-textobjects.select')
      for _, map in ipairs({
        { { 'x', 'o' }, 'af', '@function.outer' },
        { { 'x', 'o' }, 'if', '@function.inner' },
        { { 'x', 'o' }, 'ac', '@class.outer' },
        { { 'x', 'o' }, 'ic', '@class.inner' },
        { { 'x', 'o' }, 'aa', '@parameter.outer' },
        { { 'x', 'o' }, 'ia', '@parameter.inner' },
        { { 'x', 'o' }, 'ad', '@comment.outer' },
        { { 'x', 'o' }, 'as', '@statement.outer' },
      }) do
        vim.keymap.set(map[1], map[2], function()
          sel.select_textobject(map[3], 'textobjects')
        end, { desc = 'Select ' .. map[3] })
      end

      -- MOVE keymaps
      local mv = require('nvim-treesitter-textobjects.move')
      for _, map in ipairs({
        { { 'n', 'x', 'o' }, ']m', mv.goto_next_start, '@function.outer' },
        { { 'n', 'x', 'o' }, '[m', mv.goto_previous_start, '@function.outer' },
        { { 'n', 'x', 'o' }, ']]', mv.goto_next_start, '@class.outer' },
        { { 'n', 'x', 'o' }, '[[', mv.goto_previous_start, '@class.outer' },
        { { 'n', 'x', 'o' }, ']M', mv.goto_next_end, '@function.outer' },
        { { 'n', 'x', 'o' }, '[M', mv.goto_previous_end, '@function.outer' },
        { { 'n', 'x', 'o' }, ']o', mv.goto_next_start, { '@loop.inner', '@loop.outer' } },
        { { 'n', 'x', 'o' }, '[o', mv.goto_previous_start, { '@loop.inner', '@loop.outer' } },
      }) do
        local modes, lhs, fn, query = map[1], map[2], map[3], map[4]
        -- build a human-readable desc
        local qstr = (type(query) == 'table') and table.concat(query, ',') or query
        vim.keymap.set(modes, lhs, function()
          fn(query, 'textobjects')
        end, { desc = 'Move to ' .. qstr })
      end
    end,
  },
})

on_plugin_update('nvim-treesitter', function()
  -- Re-install and update parsers.
  require('nvim-treesitter').install(ensure_installed):wait(300000)
  require('nvim-treesitter').update():wait(300000)
end)
