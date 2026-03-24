-- https://github.com/microsoft/vscode/blob/main/src/vs/base/common/codicons.ts
-- go to the above and then enter <c-v>u<unicode> and the symbold should appear
-- or go here and upload the font file: https://mathew-kurian.github.io/CharacterMap/
-- find more here: https://www.nerdfonts.com/cheat-sheet

local M = {}

M.kind = {
  Array = '',
  Boolean = '',
  Class = '',
  Color = '',
  Constant = '',
  Constructor = '',
  Enum = '',
  EnumMember = '',
  Event = '',
  Field = '',
  File = '',
  Folder = '',
  Function = '',
  Interface = '',
  Keyword = '',
  Method = '',
  Module = '',
  Number = '',
  Object = '',
  Operator = '',
  Property = '',
  Reference = '',
  Snippet = '',
  String = '',
  Struct = '',
  Text = '',
  TypeParameter = '',
  Unit = '',
  Value = '',
  Variable = '',
  Copilot = '',
}

M.git = {
  added = '',
  branch = '',
  modified = '',
  removed = '',
}

M.diagnostics = {
  Error = '',
  Hint = '󰌵',
  Information = '',
  Question = '',
  Warning = '',
}

M.misc = {
  Robot = '󰚩',
  Tag = '',
  Telescope = '',
  Spaces = '󰞔',
  Octoface = '',
  VerticalBar = '│',
  Bookmark = '󰃀',
}

return M

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
