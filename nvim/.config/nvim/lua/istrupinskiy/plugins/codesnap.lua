return {
    "mistricky/codesnap.nvim",
    build = "make",
    keys = {
        { "<leader>cc", ":CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
    },
    opts = {
        has_breadcrumbs = true,
        bg_theme = "peach",
        watermark = "",
        breadcrumbs_separator = "/",
        has_breadcrumbs = true,
        has_line_number = true,
    },
}
