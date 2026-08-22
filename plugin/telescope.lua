vim.pack.add({
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim', setup = false },
  { src = 'https://github.com/nvim-telescope/telescope-ui-select.nvim', setup = false },
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', setup = false },
  { src = 'https://github.com/nvim-telescope/telescope-live-grep-args.nvim', setup = false },
})

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if kind ~= 'install' and kind ~= 'update' then
      return
    end

    if name == 'telescope-fzf-native.nvim' and vim.fn.executable('make') == 1 then
      vim.system({ 'make' }, { cwd = ev.data.path }):wait()
    end
  end,
})

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  once = true,
  callback = function()
    local actions = require('telescope.actions')
    local lga_actions = require('telescope-live-grep-args.actions')
    local builtin = require('telescope.builtin')
    local action_state = require('telescope.actions.state')

    -- Never listed, not even when hidden files are toggled on.
    local exclude = { '.git', '.jj', 'node_modules', '.venv', '__pycache__' }

    -- Lua patterns for telescope's own post-filter. They are matched against
    -- the whole path, which is relative for find_files but absolute for
    -- oldfiles/lsp pickers, hence the two anchors per name.
    local file_ignore_patterns = {}
    for _, name in ipairs(exclude) do
      local esc = vim.pesc(name)
      vim.list_extend(file_ignore_patterns, { '^' .. esc .. '/', '/' .. esc .. '/' })
    end

    -- The same list as rg/fd flags, so those trees are never walked to begin
    -- with instead of being filtered out after the fact.
    local function exclude_args(flag)
      return vim.iter(exclude)
        :map(function(name) return flag .. name end)
        :totable()
    end

    require('telescope').setup({
      defaults = {
        file_ignore_patterns = file_ignore_patterns,
        mappings = {
          i = {
            ['<C-u>'] = actions.preview_scrolling_up,
            ['<C-d>'] = actions.preview_scrolling_down,
            ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
          },
        },
      },
      extensions = {
        ['ui-select'] = { require('telescope.themes').get_dropdown() },
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = { -- extend mappings
            i = {
              -- ['<C-k>'] = lga_actions.quote_prompt(),
              ['<C-i>'] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
              -- freeze the current list and start a fuzzy search in the frozen list
              ['<C-space>'] = lga_actions.to_fuzzy_refine,
            },
          },
        },
      },
    })

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'live_grep_args')

    -- Wraps a picker so `<M-h>` re-opens it with hidden/ignored files toggled,
    -- carrying over the current prompt and cwd. The state is kept in the
    -- closure, so the choice sticks for the rest of the session.
    -- cfg = { picker = fn, title = string, opts = table, hidden = table }
    local function toggle_hidden(cfg)
      local show_hidden = false

      local function open(opts)
        opts = vim.tbl_extend('force', cfg.opts or {}, opts or {}, show_hidden and cfg.hidden or {})
        opts.prompt_title = show_hidden and cfg.title .. ' <ALL>' or cfg.title

        opts.attach_mappings = function(_, map)
          map({ 'n', 'i' }, '<M-h>', function(prompt_bufnr)
            local cwd = action_state.get_current_picker(prompt_bufnr).cwd
            local prompt = action_state.get_current_line()

            actions.close(prompt_bufnr)
            show_hidden = not show_hidden
            open({ default_text = prompt, cwd = cwd })
          end)

          return true
        end

        cfg.picker(opts)
      end

      return open
    end

    -- Built once: telescope appends `--hidden`/`--no-ignore` into this table in
    -- place, so it has to be a fresh one on every call.
    local find_command
    if vim.fn.executable('rg') == 1 then
      find_command = function()
        return vim.list_extend({ 'rg', '--files', '--color', 'never' }, exclude_args('--glob=!'))
      end
    elseif vim.fn.executable('fd') == 1 then
      find_command = function()
        return vim.list_extend({ 'fd', '--type', 'f', '--color', 'never' }, exclude_args('--exclude='))
      end
    end

    local ts_find_files = toggle_hidden({
      picker = builtin.find_files,
      title = 'Find Files',
      opts = { find_command = find_command },
      hidden = { hidden = true, no_ignore = true },
    })

    local ts_live_grep = toggle_hidden({
      picker = function(opts) require('telescope').extensions.live_grep_args.live_grep_args(opts) end,
      title = 'Live Grep',
      opts = { additional_args = function() return exclude_args('--glob=!') end },
      hidden = {
        additional_args = function()
          return vim.list_extend({ '--hidden', '--no-ignore' }, exclude_args('--glob=!'))
        end,
      },
    })

    -- stylua: ignore start
    vim.keymap.set('n', '<leader>ff', ts_find_files, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = 'Buffers' })
    vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[F]ind [R]ecent' })
    vim.keymap.set('n', '<leader>fg', ts_live_grep, { desc = '[F]ile [G]rep' })
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
    vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzy search current buffer' })
    vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = '[G]it [F]iles' })
    vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
    -- stylua: ignore end
  end,
})
