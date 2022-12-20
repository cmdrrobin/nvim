M = {}

local lualine_loaded, lualine = pcall(require, "lualine")
if not lualine_loaded then
    return
end

local icons = require "grtrs.icons"

local hide_in_width = function()
    return vim.o.columns > 80
end

local hide_in_width_100 = function()
    return vim.o.columns > 100
end

-- check if value in table
local function contains(t, value)
    for _, v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

local ui_disable_filetypes = {
    "help",
    "packer",
    "neogitstatus",
    "NvimTree",
    "Trouble",
    "lir",
    "Outline",
    "spectre_panel",
    "DressingSelect",
    "",
}

local scrollbar = {
    function()
        local current_line = vim.fn.line "."
        local total_lines = vim.fn.line "$"
        local chars = { "  ", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
        local line_ratio = current_line / total_lines
        local index = math.ceil(line_ratio * #chars)
        return chars[index]
    end,
    padding = { left = 0, right = 0 },
    cond = nil,
}

local spaces = {
    function()
        local buf_ft = vim.bo.filetype

        local space = ""

        if contains(ui_disable_filetypes, buf_ft) then
            space = " "
        end

        return "  " .. vim.api.nvim_buf_get_option(0, "shiftwidth") .. space
    end,

    padding = 0,
    separator = "%#SLSeparator#" .. " " .. "%*",
    cond = hide_in_width_100,
}

local lanuage_server = {
    function()
        local buf_ft = vim.bo.filetype

        if contains(ui_disable_filetypes, buf_ft) then
            return M.language_servers
        end

        local clients = vim.lsp.buf_get_clients()
        local client_names = {}
        local copilot_active = false

        -- add client
        for _, client in pairs(clients) do
            if client.name ~= "copilot" and client.name ~= "null-ls" then
                table.insert(client_names, client.name)
            end
            if client.name == "copilot" then
                copilot_active = true
            end
        end

        -- add formatter
        local s = require "null-ls.sources"
        local available_sources = s.get_available(buf_ft)
        local registered = {}
        for _, source in ipairs(available_sources) do
            for method in pairs(source.methods) do
                registered[method] = registered[method] or {}
                table.insert(registered[method], source.name)
            end
        end

        local formatter = registered["NULL_LS_FORMATTING"]
        local linter = registered["NULL_LS_DIAGNOSTICS"]
        if formatter ~= nil then
            vim.list_extend(client_names, formatter)
        end
        if linter ~= nil then
            vim.list_extend(client_names, linter)
        end

        -- join client names with commas
        local client_names_str = table.concat(client_names, ", ")

        -- check client_names_str if empty
        local language_servers = ""
        local client_names_str_len = #client_names_str
        if client_names_str_len ~= 0 then
            language_servers = "%#SLLSP#" .. "[" .. client_names_str .. "]" .. "%*"
        end
        if copilot_active then
            language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
        end

        if client_names_str_len == 0 and not copilot_active then
            return ""
        else
            M.language_servers = language_servers
            return language_servers
        end
    end,
    padding = 0,
    separator = "%#SLSeparator#" .. " " .. "%*",
    cond = hide_in_width,
}

-- Change text color for lanuage_server output
vim.api.nvim_set_hl(0, "SLLSP", { fg = "#616E88" })

lualine.setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { lanuage_server, spaces, 'filetype' },
        lualine_y = { 'location' },
        lualine_z = { scrollbar }
    },
}
