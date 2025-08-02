return {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp", -- Use this branch for the new version
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
    opts = {
        settings = {
            options = {
                notify_user_on_venv_activation = true,
            },
        },
    },
    --  Call config for python files and load the cached venv automatically
    --  Note this plugin requries fd to be installed on your system (`brew install fd` on a mac)
    event = 'VeryLazy',
    ft = "python",
    keys = { { "<leader>vs", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
}
