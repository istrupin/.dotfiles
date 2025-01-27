return {
    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.6',
        -- or                            , branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim' } },
        keys = {
            { '<leader>pf', function() require("telescope.builtin").find_files({ find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } }) end },
            { '<leader>p.', function() require("telescope.builtin").find_files({ find_command = { 'rg', '--files', '-g', '!.git' } }) end },
            { '<leader>pc', function() require("telescope.builtin").commands() end },
            { '<C-p>',      function() require("telescope.builtin").git_files() end },
            { '<leader>pg', function() require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") }); end },
            { '<leader>ps', function() require("telescope.builtin").grep_string(); end },
            { '<leader>pl', function() require("telescope.builtin").live_grep({}); end },
            { '<leader>ph', function() require("telescope.builtin").help_tags({}); end },
        },
        config = function(_, opts)
            require("telescope").setup{
                extensions = {
                    fzf = {}
                }
            }
        end
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = function(_, opts)
            require('telescope').load_extension('fzf')
        end
    }
}
