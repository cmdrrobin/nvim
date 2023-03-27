return {
    -- Plugin: LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- LSP Support
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "folke/neodev.nvim",
        },
        lazy = true,
    },
    -- Plugin: Autocompletion
    { "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        version = false, -- last release is way too old
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lua",

            -- Snippets
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
        },
        opts = function()
            local cmp = require("cmp")

            local luasnip_loaded, luasnip = pcall(require, "luasnip")
            if not luasnip_loaded then return end

            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" }})

            vim.keymap.set({ "i", "s" }, "<C-j>", function()
                if luasnip.choice_active() then
                    luasnip.change_choice(1)
                end
            end)

            vim.keymap.set({ "i", "s" }, "<C-k>", function()
                if luasnip.choice_active() then
                    luasnip.change_choice( -1)
                end
            end)

            local icons = require("grtrs.icons")

            -- Update completion via lsp-zero
            return {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs( -4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true
                    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable( -1) then
                            luasnip.jump( -1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = {
                    { name = 'path' },
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = "copilot", },
                    { name = 'buffer' },
                    { name = 'luasnip' },
                },
                formatting = {
                    kind_icons = icons.kind,
                    format = function(entry, item)
                        if icons.kind[item.kind] then
                            item.kind = icons.kind[item.kind] .. " " .. item.kind
                        end

                        if entry.source.name == "copilot" then
                            item.kind = icons.git.Octoface .. " " .. item.kind
                            item.kind_hl_group = "CmpItemKindCopilot"
                        end

                        return item
                    end,
                }
            }
        end
    },
    -- Plugin: for formatters and linters
    { "jose-elias-alvarez/null-ls.nvim", lazy = true },
}
