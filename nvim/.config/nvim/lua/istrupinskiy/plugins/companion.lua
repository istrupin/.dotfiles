return {
    "olimorris/codecompanion.nvim",
    opts = {
        stream = false,
        log_level = "TRACE",
        strategies = {
            chat = {
                adapter = "litellm",
                slash_commands = {
                    ["file"] = {
                        opts = {
                            provider = "telescope"
                        }
                    }
                }
            },
            inline = {
                adapter = "litellm",
            },
        },
        adapters = {
            http = {
                opts = {
                    log_level = "TRACE",
                    show_defaults = false
                },
            litellm = function()
                local l_env = require("istrupinskiy.llm_env")
                return require("codecompanion.adapters").extend("openai_compatible", {
                    name = "litellm",
                    env = l_env,
                    opts = {
                        stream = false,
                    },
                    schema = {
                        model = {
                            -- default = "claude-3-7-sonnet",
                            -- default = "claude-opus-4",
                            default = "claude-sonnet-4",
                            choices = {}
                        }
                    }

                })
            end,
            }
        },
    },

    init = function()
        require("istrupinskiy.companion_fidget"):init()
    end,

    config = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "j-hui/fidget.nvim"
    },
}
