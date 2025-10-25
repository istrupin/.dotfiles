return {

    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.8',
        -- or                            , branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    },

    'nvim-treesitter/playground',
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
