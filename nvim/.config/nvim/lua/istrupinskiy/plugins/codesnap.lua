return {
    "mistricky/codesnap.nvim",
    keys = {
        { "<leader>cc", ":CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
    },
    opts = {
        show_line_number = true,
        snapshot_config = {
            theme = "rose-pine",
            themes_folders = { "~/.config/bat/themes" },
            watermark = { content = "" },
            code_config = {
                breadcrumbs = {
                    enable = true,
                    separator = "/",
                },
            },
            background = {
                start = { x = 0, y = 0 },
                ["end"] = { x = "max", y = "max" },
                stops = {
                    { position = 0, color = "#FBC2EB" },
                    { position = 0.5, color = "#C2A0F4" },
                    { position = 1, color = "#A6C1EE" },
                },
            },
        },
    },
}
