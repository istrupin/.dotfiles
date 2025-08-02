return {
    "nvim-neorg/neorg",
    -- lazy = false,
    opts = {
        load = {
            ["core.defaults"] = {},
            ["core.export"] = {},
            ["core.concealer"] = {},
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        notes = "~/notes",
                    },
                    default_workspace = "notes",
                },
            },
        },
    },
    config = function(_, opts)
        vim.wo.foldlevel = 99
        vim.wo.conceallevel = 2
        require("neorg").setup(opts)
    end
}
