local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

return {
    'nvimtools/none-ls.nvim',
    config = function(_, opts)
        local null_ls = require("null-ls")
        -- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        null_ls.setup({
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                            -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
                            -- vim.lsp.buf.formatting_sync()
                            vim.lsp.buf.format({
                                async=false,
                                filter= function(ls_client)
                                    return ls_client.name == "null-ls"
                                end
                            })
                        end,
                    })
                end
            end,
            sources = {
                null_ls.builtins.formatting.prettier
            }
        })
    end

}

