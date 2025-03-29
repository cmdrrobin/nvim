return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = function(_, opts)
      if not vim.g.have_icons then
        opts.icons = opts.icons or {}
        opts.icons.rules = false
      end
    end,
    config = function(_, opts) -- This is the function that runs, AFTER loading
      require('which-key').setup(opts)

      -- Document existing key chains
      require('which-key').add({
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      })
    end,
  },
}
