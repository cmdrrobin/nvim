-- Pretty icons for Neovim built-in LSP, Treesitter, and more.
return {
  'nvim-tree/nvim-web-devicons',
  event = { 'BufReadPost', 'BufNewFile' },
  enabled = vim.g.have_icons,
  opts = {
    override_by_filename = {
      ['.gitattributes'] = {
        icon = '',
        color = '#e24329',
        cterm_color = '59',
        name = 'GitAttributes',
      },
      ['.gitconfig'] = {
        icon = '',
        color = '#e24329',
        cterm_color = '59',
        name = 'GitConfig',
      },
      ['.gitignore'] = {
        icon = '',
        color = '#e24329',
        cterm_color = '59',
        name = 'GitIgnore',
      },
      ['.gitmodules'] = {
        icon = '',
        color = '#e24329',
        cterm_color = '59',
        name = 'GitModules',
      },
      ['pp'] = {
        icon = '',
        color = '#FFA61A',
        name = 'Pp',
      },
      ['epp'] = {
        icon = '',
        color = '#FFA61A',
        name = 'Epp',
      },
      ['tf'] = {
        icon = '󱁢',
        color = '#5F43E9',
        cterm_color = '57',
        name = 'Terraform',
      },
      ['tfvars'] = {
        icon = '󱁢',
        color = '#5F43E9',
        cterm_color = '57',
        name = 'TFVars',
      },
      ['astro'] = {
        --  󱓟 
        icon = '󱓞',
        color = '#FF7E33',
        name = 'Astro',
      },
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
