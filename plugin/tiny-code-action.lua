vim.pack.add({
  { src = 'https://github.com/rachartier/tiny-code-action.nvim' },
}, { load = false })

vim.api.nvim_create_autocmd('LspAttach', {
  once = true,
  callback = function()
    vim.cmd.packadd('tiny-code-action.nvim')

    vim.keymap.set({ 'n', 'x' }, '<leader>ca', function()
      require('tiny-code-action').code_action()
    end, { noremap = true, silent = true })
  end,
})
