local VENV = ".venv"
local uv = vim.uv or vim.loop

-- `--no-cov` is provided by the pytest-cov plugin; if it isn't installed,
-- pytest aborts with "unrecognized arguments: --no-cov". Only pass it when
-- pytest-cov is present in the project's venv. Uses libuv rather than
-- vim.fn.glob so it's safe in the fast event context neotest builds specs in.
-- Paths are relative to cwd, the same base neotest uses to run
-- `.venv/bin/python`, so the check and the runner always agree.
local function has_pytest_cov()
    local lib = VENV .. "/lib"
    local dir = uv.fs_scandir(lib)
    if not dir then
        return false
    end
    while true do
        local name = uv.fs_scandir_next(dir)
        if not name then
            return false
        end
        if name:find("^python") and uv.fs_stat(lib .. "/" .. name .. "/site-packages/pytest_cov") then
            return true
        end
    end
end

local function pytest_args()
    return has_pytest_cov() and { "--no-cov" } or {}
end

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
                        args = pytest_args,
                        dap = { justMyCode = false },
                        python = VENV .. "/bin/python",
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
