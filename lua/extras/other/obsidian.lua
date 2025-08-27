---@module 'lazy'
---@type LazySpec
return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  cmd = {
    'Obsidian',
  },
  keys = {
    { '<leader>on', '<cmd>Obsidian new<CR>', desc = 'Obsidian: New Note' },
    { '<leader>ot', '<cmd>Obsidian today<CR>', desc = 'Obsidian: create/open daily note' },
    { '<leader>oy', '<cmd>Obsidian yesterday<CR>', desc = 'Obsidian: create/open yesterday daily note' },
    { '<leader>os', '<cmd>Obsidian search<CR>', desc = 'Obsidian: search notes' },
  },
  ---@module 'obsidiam'
  ---@type obsidian.config.ClientOpts
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    legacy_commands = false,
    ui = {
      enable = false,
    },
    workspaces = {
      {
        name = 'zettelkasten',
        path = vim.fn.expand('$HOME/.config/zettelkasten'),
      },
    },
    notes_subdir = 'Inbox',
    daily_notes = {
      folder = 'Journal',
      date_format = '%Y-%m-%d',
    },
    ---@param title? string
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ''
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. '-' .. suffix
    end,
  },
  config = function(_, opts)
    require('obsidian').setup(opts)
  end,
}
