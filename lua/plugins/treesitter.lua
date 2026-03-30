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
}, { confirm = false })

local TS = require('nvim-treesitter')

-- Setup treesitter
TS.setup()

-- ensure basic parsers are installed
TS.install(ensure_installed)

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
