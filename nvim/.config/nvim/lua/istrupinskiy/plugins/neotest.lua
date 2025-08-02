return {
    { "nvim-neotest/neotest-python" },
    { "nvim-neotest/neotest-jest" },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        runner = "pytest",
                        args = {"--no-cov" },
                        dap = { justMyCode = true },
                        python = ".venv/bin/python",
                    }),
                    require("neotest-jest")({
                        jestCommand = "npm test --",
                        cwd = function(path)
                            return vim.fn.getcwd()
                        end,

                    })
                },
                quickfix = {
                    enabled = true,
                    open = function() vim.cmd("copen") end
                }
            })
        end,
        keys = {
            { "<leader>t",  "",                                                                                 desc = "+test" },
            { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run File" },
            { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end,                            desc = "Run All Test Files" },
            { "<leader>tU", function() require("neotest").run.run({
                vim.uv.cwd(),
                extra_args = {"-m not integration"}}) end,                                                      desc = "Run Unit Tests in All Files" },
            { "<leader>tu", function() require("neotest").run.run({
                vim.fn.expand("%"),
                extra_args = {"-m not integration"}}) end,                                                      desc = "Run Unit Tests in File" },
            { "<leader>tr", function() require("neotest").run.run() end,                                        desc = "Run Nearest" },
            { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,                    desc = "Debug Nearest" },
            { "<leader>tl", function() require("neotest").run.run_last() end,                                   desc = "Run Last" },
            { "<leader>ts", function() require("neotest").summary.toggle() end,                                 desc = "Toggle Summary" },
            { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end,                            desc = "Toggle Output Panel" },
            { "<leader>tS", function() require("neotest").run.stop() end,                                       desc = "Stop" },
            { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end,                 desc = "Toggle Watch" },
        },
    },
}
