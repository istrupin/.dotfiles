return {
    "danymat/neogen",
    config = true,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*" 
    opts = {
        snippet_engine = "luasnip",
        -- languages = {
        --     python = {
        --         template = {
        --             annotation_convention = "numpydoc"
        --         }
        --     }
        -- }
    },
    keys = {
        {"<leader>nf", function() require('neogen').generate()  end}
    }
}
