return {
    "ggandor/leap.nvim",
    dependencies = {"tpope/vim-repeat"},
    config =  function(_, opts)
        local leap = require('leap')
        leap.create_default_mappings()
        -- vim.keymap.set('n', 'z', '<Plug>(leap-forward)')
    end

}
