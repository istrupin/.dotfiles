return {
-- Conjure!
  -- {'Olical/conjure', ft="clojure"},
{
    "Olical/conjure",
    ft = { "clojure", "fennel" }, -- etc
    lazy = true,
    init = function()
      -- Set configuration options here
      -- Uncomment this to get verbose logging to help diagnose internal Conjure issues
      -- This is VERY helpful when reporting an issue with the project
      -- vim.g["conjure#debug"] = true
    end,

    -- Optional cmp-conjure integration
    dependencies = { "PaterJason/cmp-conjure" },
  },
  {
    "PaterJason/cmp-conjure",
    lazy = true,
    config = function()
      local cmp = require("cmp")
      local config = cmp.get_config()
      table.insert(config.sources, { name = "conjure" })
      return cmp.setup(config)
    end,
  },
  -- Structural editing, optional
  -- {'tpope/vim-sexp-mappings-for-regular-people', ft="clojure"},
  -- {'guns/vim-sexp', ft="clojure"},
  -- {'gpanders/nvim-parinfer', ft="clojure"}
  {
      'dundalek/parpar.nvim',
      dependencies = { "gpanders/nvim-parinfer", "julienvincent/nvim-paredit" },
      ft={"clojure", "edn"},
      config = function()
        local paredit = require("nvim-paredit")
        require("parpar").setup {

        }
      end
  }

}
