---@module 'lazy'
---@type LazySpec
return {
  {
    'echasnovski/mini.files',
    version = false,
    opts = {
      mappings = {
        show_help = '?',
        go_in_plus = '<cr>',
        go_out_plus = '<tab>',
      },
    },
    keys = {
      {
        '<leader>pv',
        function()
          local bufname = vim.api.nvim_buf_get_name(0)
          local path = vim.fn.fnamemodify(bufname, ':p')

          -- Noop if the buffer isn't valid.
          if path and vim.uv.fs_stat(path) then
            require('mini.files').open(bufname, false)
          end
        end,
        desc = 'File explorer',
      },
    },
    config = function(_, opts)
      require('mini.files').setup(opts)
    end,
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
