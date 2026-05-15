-- LSP: native vim.lsp.config / vim.lsp.enable (Neovim 0.11+).
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.opt.signcolumn = 'yes'
vim.o.winborder = 'rounded'

-- Global defaults for every server.
vim.lsp.config('*', {
    capabilities = capabilities,
})

-- Trim server filetypes to the ones Neovim actually knows:
--   .edn    -> clojure        (see set.lua)
--   .mdx    -> markdown       (see set.lua)
--   .tfvars -> terraform      (see set.lua)
vim.lsp.config('clojure_lsp', { filetypes = { 'clojure' } })
vim.lsp.config('marksman',    { filetypes = { 'markdown' } })
vim.lsp.config('terraformls', { filetypes = { 'terraform' } })

-- Pin ruff to UTF-16 so it matches pyright on shared buffers (avoids the
-- "buffers attached to clients with different position encodings" warning).
vim.lsp.config('ruff', {
    capabilities = vim.tbl_deep_extend('force', {}, capabilities, {
        general = { positionEncodings = { 'utf-16' } },
    }),
})

-- Pyright registers a "**" workspace watcher and emits a $/progress cycle for
-- every reanalysis triggered by background filesystem activity. Forward only
-- the first progress token; drop the rest so we get one connect toast and
-- silence after.
vim.lsp.config('pyright', {
    handlers = {
        ['$/progress'] = function(err, result, ctx)
            if result.token == (vim.g.pyright_progress_token or result.token) then
                vim.g.pyright_progress_token = result.token
                vim.lsp.handlers['$/progress'](err, result, ctx)
            end
        end,
    },
})

-- Diagnostic UI.
vim.diagnostic.config({
    float = { border = 'rounded' },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN]  = '▲',
            [vim.diagnostic.severity.HINT]  = '⚑',
            [vim.diagnostic.severity.INFO]  = '',
        },
    },
})

vim.keymap.set('n', 'gl', vim.diagnostic.open_float)

-- Buffer-local keymaps on attach. 0.11+ natively provides grn/grr/gri/gra/[d/]d,
-- so we only add gd (definition) and K (hover).
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('istrupinskiy.lsp', { clear = true }),
    callback = function(ev)
        local bufopts = { buffer = ev.buf, silent = true }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    end,
})

-- Format on save for ruff (python) and clojure_lsp (clojure).
vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('istrupinskiy.lsp.format', { clear = true }),
    callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        local formatters = {
            python = 'ruff',
            clojure = 'clojure_lsp',
        }
        local wanted = formatters[ft]
        if not wanted then return end
        vim.lsp.buf.format({
            bufnr = ev.buf,
            async = false,
            timeout_ms = 10000,
            filter = function(client) return client.name == wanted end,
        })
    end,
})

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'eslint', 'lua_ls', 'pyright', 'ruff',
        'terraformls', 'clojure_lsp', 'ts_ls', 'marksman',
    },
    automatic_enable = true,
})

-- nvim-cmp
local luasnip = require('luasnip')
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'luasnip' },
        { name = 'buffer' },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),

    enabled = function()
        return vim.bo[0].buftype ~= "prompt"
            or require("cmp_dap").is_dap_buffer()
    end
})

require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
        { name = "dap" },
    },
})

cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        {
            name = 'cmdline',
            option = {
                ignore_cmds = { 'Man', '!' }
            }
        }
    })
})
