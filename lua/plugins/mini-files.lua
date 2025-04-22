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

      -- Make it possible to enable preview window
      -- https://github.com/echasnovski/mini.nvim/issues/1514
      local toggle_preview = function()
        MiniFiles.config.windows.preview = not MiniFiles.config.windows.preview
        MiniFiles.refresh({})
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Tweak left-hand side of mapping to your liking
          vim.keymap.set('n', 'gp', toggle_preview, { buffer = buf_id })
        end,
      })
    end,
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
