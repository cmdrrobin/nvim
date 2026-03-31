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

vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', data = { build = 'TSUpdate' } },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
  'https://github.com/nvim-treesitter/nvim-treesitter-context', -- show context of current cursor position
}, { confirm = false })

local TS = require('nvim-treesitter')

-- Setup treesitter
TS.setup()

-- ensure basic parsers are installed
TS.install(ensure_installed)

require('nvim-treesitter-textobjects').setup()

require('treesitter-context').setup({
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  throttle = true, -- Throttles plugin updates (may improve performance)
  max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
  multiline_threshold = 1, -- Match the context lines to the source code.
})

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  -- check if parser exists and load it
  if not vim.treesitter.language.add(language) then
    return
  end
  -- enables syntax highlighting and other treesitter features
  vim.treesitter.start(buf, language)

  -- enables treesitter based folds
  -- for more info on folds see `:help folds`
  -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

  -- enables treesitter based indentation
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

local available_parsers = TS.get_available()

-- Custom autocmd just for attachment (installation handled natively)
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('cmdrrobin-treesitter', { clear = true }),
  callback = function(args)
    local buf, filetype = args.buf, args.match
    local language = vim.treesitter.language.get_lang(filetype)
    if not language then
      return
    end

    -- Check fresh each time (not cached at load time)
    local installed_parsers = TS.get_installed('parsers')

    if vim.tbl_contains(installed_parsers, language) then
      -- enable the parser if it is installed
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      -- if a parser is available in `nvim-treesitter` enable it after ensuring it is installed
      TS.install(language):await(function()
        treesitter_try_attach(buf, language)
      end)
    else
      -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
      treesitter_try_attach(buf, language)
    end
  end,
})

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
