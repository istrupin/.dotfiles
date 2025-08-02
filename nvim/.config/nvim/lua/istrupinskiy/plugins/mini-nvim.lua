return {
    'echasnovski/mini.nvim',
    -- dependencies are for function definition querying in mini.ai
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/nvim-treesitter',
    },
    event = "VeryLazy",
    version = false,
    config = function(_, opts)
        require('mini.bracketed').setup({
            undo = { suffix = '', options = {} },
            comment = {suffix = 'z', options = {}},
        })
        local ai = require("mini.ai")
        ai.setup({
            custom_textobjects = {
                -- for function definition.  This way, 'f' is function call, 'F' is function definition
                F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
                o = ai.gen_spec.treesitter({ -- code block
                    a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                    i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                }),
            }
        })
        require('mini.icons').setup()
        require('mini.pairs').setup()
    end
}
