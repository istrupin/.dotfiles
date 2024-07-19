return { 
    'echasnovski/mini.nvim',
    version = false,
    config = function(_, opts)
        require('mini.bracketed').setup({
            undo       = { suffix = '', options = {} },
        })
    end
}

