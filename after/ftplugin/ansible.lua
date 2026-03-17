-- ansible-language-server shows a message request with a `ENOENT` error
-- if the file does not exist on disk. Ensure it does
if vim.bo.buftype == '' then
  local stat = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
  if not stat then
    vim.fn.mkdir(vim.fn.expand('%p:h'), 'p')
    vim.cmd('w')
  end
end
