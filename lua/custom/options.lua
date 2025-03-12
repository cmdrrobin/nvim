-- convert tabs to spaces
vim.o.expandtab = true

-- the number of spaces inserted for each indentation
vim.opt.shiftwidth = 4

-- insert spaces for a tab
vim.opt.tabstop = 4

-- Number of spaces that a tab counts for while performing editing operations
vim.opt.softtabstop = 4

-- Do smart autoindenting when starting a new line
vim.opt.smartindent = true

-- Don't have `o` add a comment
vim.opt.formatoptions:remove('o')

-- Netrw settings
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_bufsettings = 'nu'

-- always write files as utf-8
vim.g.fileencoding = 'utf-8'

-- only the last window will always have a status line
vim.opt.laststatus = 3
