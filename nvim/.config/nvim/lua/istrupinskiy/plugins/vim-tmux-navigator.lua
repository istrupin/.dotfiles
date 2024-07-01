return {
    "christoomey/vim-tmux-navigator",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        -- { "<c-w>h", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        -- { "<c-w>j", "<cmd><C-U>TmuxNavigateDown<cr>" },
        -- { "<c-w>k", "<cmd><C-U>TmuxNavigateUp<cr>" },
        -- { "<c-w>l", "<cmd><C-U>TmuxNavigateRight<cr>" },
        -- { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" }
    },
}
