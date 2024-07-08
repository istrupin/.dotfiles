return {
    "christoomey/vim-tmux-navigator",
    init = function()
        vim.g.tmux_navigator_no_mappings = 1

    end,
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    keys = {
        { "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd>TmuxNavigateRight<cr>" },
        -- { "<c-w>h", "<cmd>TmuxNavigateLeft<cr>" },
        -- { "<c-w>j", "<cmd>TmuxNavigateDown<cr>" },
        -- { "<c-w>k", "<cmd>TmuxNavigateUp<cr>" },
        -- { "<c-w>l", "<cmd>TmuxNavigateRight<cr>" },
        -- { "<c-/>", "<cmd>TmuxNavigatePrevious<cr>" }
    },
}
