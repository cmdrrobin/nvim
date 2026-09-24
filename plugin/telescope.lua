vim.pack.add({
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim', setup = false },
  { src = 'https://github.com/nvim-telescope/telescope-ui-select.nvim', setup = false },
})

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  once = true,
  callback = function()
    local actions = require('telescope.actions')
    local builtin = require('telescope.builtin')

    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = actions.preview_scrolling_up,
            ['<C-d>'] = actions.preview_scrolling_down,
            ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'ui-select')

    -- stylua: ignore start
    vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = 'Buffers' })
    vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[F]ind [R]ecent' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
    vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzy search current buffer' })
    vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = '[G]it [F]iles' })
    vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
    -- stylua: ignore end
  end,
})
