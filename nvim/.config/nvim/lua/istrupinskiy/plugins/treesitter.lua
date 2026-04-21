return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
        dependencies = {
            "LiadOz/nvim-dap-repl-highlights",
            { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
        },
        lazy = false,
        init = function()
            local want = {
                'javascript', 'typescript', 'python', 'c', 'lua', 'vim', 'vimdoc',
                'query', 'bash', 'markdown', 'markdown_inline', 'dap_repl',
                'clojure', 'fennel', 'just',
            }

            require('nvim-dap-repl-highlights').setup()

            local ok, have = pcall(function()
                return require('nvim-treesitter.config').get_installed()
            end)
            if ok then
                local missing = vim.iter(want)
                    :filter(function(p) return not vim.tbl_contains(have, p) end)
                    :totable()
                if #missing > 0 then
                    require('nvim-treesitter').install(missing)
                end
            end

            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup('istrupinskiy.treesitter', { clear = true }),
                callback = function(ev)
                    local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
                    if lang and vim.treesitter.language.add(lang) then
                        pcall(vim.treesitter.start, ev.buf, lang)
                        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })

            -- Incremental selection via treesitter (bypasses mini.ai's a/i prefix).
            -- <C-Space> grows selection to enclosing node, <BS> shrinks back.
            local stack = {}
            local updating = false  -- guard so our own mode changes don't wipe the stack

            local function reselect(node)
                local sr, sc, er, ec = node:range()
                -- Tree-sitter end positions are exclusive; some nodes (e.g. markdown's
                -- top-level document) end at (line_count, 0), past the buffer. Clamp
                -- only in that case so we don't change behavior for in-bounds nodes.
                local last = vim.api.nvim_buf_line_count(0) - 1
                if er > last then
                    er = last
                    ec = #(vim.api.nvim_buf_get_lines(0, last, last + 1, false)[1] or '')
                end
                updating = true
                if vim.fn.mode() ~= 'n' then
                    vim.cmd('normal! \27')
                end
                vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
                vim.cmd('normal! v')
                vim.api.nvim_win_set_cursor(0, { er + 1, math.max(0, ec - 1) })
                updating = false
            end

            local function grow()
                local node
                if #stack > 0 then
                    node = stack[#stack]:parent()
                else
                    node = vim.treesitter.get_node()
                end
                if not node then return end
                table.insert(stack, node)
                reselect(node)
            end

            local function shrink()
                if #stack <= 1 then return end
                table.remove(stack)
                reselect(stack[#stack])
            end

            vim.keymap.set({ 'n', 'x' }, '<C-Space>', grow, { silent = true })
            vim.keymap.set('x', '<BS>', shrink, { silent = true })

            -- Reset the stack only when the user leaves visual mode themselves.
            vim.api.nvim_create_autocmd('ModeChanged', {
                group = vim.api.nvim_create_augroup('istrupinskiy.ts.incsel', { clear = true }),
                pattern = '[vV\x16]*:[^vV\x16]*',
                callback = function()
                    if not updating then stack = {} end
                end,
            })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
    },
}
