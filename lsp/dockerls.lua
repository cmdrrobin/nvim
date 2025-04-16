---@brief
---
---https://github.com/rcjsuen/dockerfile-language-server-nodejs
--
-- `docker-langserver` can be installed via `npm`:
-- ```sh
-- npm install -g dockerfile-language-server-nodejs
-- ```
--
-- Additional configuration can be applied in the following way:
-- ```lua
-- vim.lsp.config('dockerls', {
--     settings = {
--         docker = {
-- 	    languageserver = {
-- 	        formatter = {
-- 		    ignoreMultilineInstructions = true,
-- 		},
-- 	    },
-- 	}
--     }
-- })
-- ```
return {
  cmd = { 'docker-langserver', '--stdio' },
  filetypes = { 'dockerfile' },
  root_markers = { 'Dockerfile' },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
