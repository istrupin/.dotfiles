return {

    {
        'nvim-telescope/telescope.nvim',
        tag = 'v0.2.1',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    },

    {
        "mbbill/undotree",
        keys =
        {
            { "<leader>u", vim.cmd.UndotreeToggle }
        }
    },
    {
        "tpope/vim-fugitive",
        keys =
        {
            { "<leader>gs", vim.cmd.Git }
        },
        lazy = false
    },
    "nvim-lua/plenary.nvim",
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { { "nvim-lua/plenary.nvim" } }
    },
    'nvim-tree/nvim-web-devicons',

}
