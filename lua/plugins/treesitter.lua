vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', data = { build = 'TSUpdate' } },
}, { confirm = false })

local TS = require('nvim-treesitter')

-- Configure native auto-install
require('nvim-treesitter').setup({
  auto_install = true,
  highlight = { enable = true },
})

-- Custom autocmd just for attachment (installation handled natively)
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match
    local language = vim.treesitter.language.get_lang(filetype)
    if not language then
      return
    end

    -- Check fresh each time (not cached at load time)
    local installed_parsers = TS.get_installed('parsers')

    if vim.tbl_contains(installed_parsers, language) then
      -- Parser is installed, enable treesitter
      if vim.treesitter.language.add(language) then
        vim.treesitter.start(buf, language)
      end
    end
    -- Native auto_install will handle installation if not installed
  end,
})

-- Initial basic parsers with proper async handling
TS.install({ 'bash', 'c', 'diff', 'go', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'python', 'query', 'vim', 'vimdoc', 'terraform' }):await()
