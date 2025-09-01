---@module 'lazy'
---@type LazySpec
return {
  {
    'echasnovski/mini.files',
    version = false,
    enabled = false,
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
      {
        '<leader>e',
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

      -- HACK: Notify LSPs that a file got renamed or moved.
      -- Borrowed this from snacks.nvim.
      vim.api.nvim_create_autocmd('User', {
        desc = 'Notify LSPs that a file was renamed',
        pattern = { 'MiniFilesActionRename', 'MiniFilesActionMove' },
        callback = function(args)
          local changes = {
            files = {
              {
                oldUri = vim.uri_from_fname(args.data.from),
                newUri = vim.uri_from_fname(args.data.to),
              },
            },
          }
          local will_rename_method, did_rename_method = vim.lsp.protocol.Methods.workspace_willRenameFiles, vim.lsp.protocol.Methods.workspace_didRenameFiles
          local clients = vim.lsp.get_clients()
          for _, client in ipairs(clients) do
            if client:supports_method(will_rename_method) then
              local res = client:request_sync(will_rename_method, changes, 1000, 0)
              if res and res.result then
                vim.lsp.util.apply_workspace_edit(res.result, client.offset_encoding)
              end
            end
          end

          for _, client in ipairs(clients) do
            if client:supports_method(did_rename_method) then
              client:notify(did_rename_method, changes)
            end
          end
        end,
      })
    end,
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
