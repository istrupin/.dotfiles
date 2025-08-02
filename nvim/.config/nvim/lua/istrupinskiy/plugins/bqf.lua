return {
    { 'kevinhwang91/nvim-bqf', ft = 'qf' },
    -- optional
    {
        'junegunn/fzf',
        config = function()
            vim.fn['fzf#install']()
        end
    }
}
