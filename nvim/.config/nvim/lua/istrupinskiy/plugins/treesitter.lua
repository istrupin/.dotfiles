return {
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            "LiadOz/nvim-dap-repl-highlights",
            'nvim-treesitter/nvim-treesitter-textobjects',
            -- "nvim-treesitter/nvim-treesitter-refactor"
        },
        build = ':TSUpdate',
        opts = {

            -- A list of parser names, or "all" (the five listed parsers should always be installed)
            ensure_installed = { "javascript", "typescript", "python", "c", "lua", "vim", "vimdoc", "query", "bash", "markdown", "markdown_inline", "dap_repl", "clojure", "fennel", "just" },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,

            highlight = {
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                }
            }

        },
        config = function(_, opts)
            require('nvim-dap-repl-highlights').setup()
            require("nvim-treesitter.install").compilers = { "gcc-14" }
            local configs = require("nvim-treesitter.configs")
            configs.setup(opts)
        end

    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
    }

}
