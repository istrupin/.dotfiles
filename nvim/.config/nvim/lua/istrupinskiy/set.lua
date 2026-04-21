-- line numberes
vim.opt.nu = true
vim.opt.relativenumber = true

-- file extension -> filetype overrides
vim.filetype.add({
    extension = {
        edn = 'clojure',       -- edn is Clojure data; reuse clojure tooling
        mdx = 'markdown',      -- lets marksman attach to .mdx
        tfvars = 'terraform',  -- lets terraformls attach to .tfvars
    },
})


-- tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.updatetime = 50

vim.opt.colorcolumn = "120"

vim.g.mapleader = " "
vim.o.exrc = true
