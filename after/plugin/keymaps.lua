-- Normal --
-- Better window navigation
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true })
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })

-- Resize with arrows
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', { silent = true })
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', { silent = true })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { silent = true })

-- Navigate buffers
vim.keymap.set('n', '<S-l>', ':bnext<CR>', { desc = 'Next Buffer' }) -- move to next buffer
vim.keymap.set('n', '<S-h>', ':bprevious<CR>', { desc = 'Previous Buffer' }) -- move to previous buffer
vim.keymap.set('n', '<S-q>', ':bd!<CR>') -- delete current buffer

-- buffer bracket motion
vim.keymap.set('n', ']b', ':bnext<CR>', { desc = 'Next Buffer' }) -- move to next buffer
vim.keymap.set('n', '[b', ':bprevious<CR>', { desc = 'Previous Buffer' }) -- move to previous buffer

-- File Explorer
vim.keymap.set('n', '<leader>pv', '<cmd>Ex<CR>', { desc = 'Open Netrw' })

-- Better paste
vim.keymap.set({ 'v', 'x' }, '<leader>p', '"_dP')

-- Better Yank
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', { silent = true })
vim.keymap.set('v', '>', '>gv', { silent = true })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { silent = true }) -- Move visual up
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { silent = true }) -- Move visual down

-- LSP
vim.keymap.set('n', '<leader>cf', '<cmd>Format<CR>', { desc = 'Format Buffer' })

-- toggle inlay hints capabilities
if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
  vim.keymap.set('n', '<leader>ih', '<cmd>InlayhintsToggle<CR>', { desc = 'Toggle Inlay Hints' })
end
