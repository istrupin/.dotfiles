local lsp_zero = require('lsp-zero')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- keybindings


local lsp_attach = function(client, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
end

vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
vim.opt.signcolumn = 'yes'

lsp_zero.extend_lspconfig({
    capabilities = capabilities,
    lsp_attach = lsp_attach,
    float_border = 'rounded',
    sign_text = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = ''
    }
})



-- lsp_zero.on_attach(function(client, bufnr)
--     -- see :help lsp-zero-keybindings
--     -- to learn the available actions
--     lsp_zero.default_keymaps({ buffer = bufnr })
-- end)

-- format on save
--
lsp_zero.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    servers = {
        ['ruff'] = { 'python' },
        ['clojure_lsp'] = {'clojure'}
        -- ['null-ls'] = { 'javascript', 'typescript' },
    }
})
--
-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {  'eslint', 'lua_ls', 'pyright', 'ruff',  'terraformls', 'clojure_lsp', 'ts_ls', 'marksman'},
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({ capabilities = capabilities })
        end,
    },
})


local luasnip = require('luasnip')
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
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
        -- { name = 'nvim_lsp_signature_help' },
    },
    mapping = cmp.mapping.preset.insert({
        -- confirm completion
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        -- prev and next
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        -- scroll up and down the documentation window
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        -- super tab
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
        -- start completion
        ['<C-Space>'] = cmp.mapping.complete(),
    }),

    -- nvim dap cmp setup
    enabled = function()
        return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
            or require("cmp_dap").is_dap_buffer()
    end
    --
})
-- more dap cmp setup
require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
        { name = "dap" },
    },
})
--
-- `/` cmdline setup.
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- `:` cmdline setup.
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




