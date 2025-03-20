return {
  'polarmutex/git-worktree.nvim',
  version = '^2',
  dependencies = { 'telescope.nvim' },
  event = 'VimEnter',
  opts = {},
  keys = {
    { '<leader>gw', "<cmd>lua require('telescope').extensions.git_worktree.git_worktree()<CR>", { silent = true, desc = 'Show Git worktrees' } },
    { '<leader>gW', "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", { silent = true, desc = 'Create Git worktree' } },
  },
  config = function()
    require('telescope').load_extension('git_worktree')
  end,
}
