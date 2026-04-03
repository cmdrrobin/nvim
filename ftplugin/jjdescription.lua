vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.o.wrap = true

-- Use gitcommit TS with Jujutsu description filetyp
vim.treesitter.language.register('gitcommit', 'jjdescription')
