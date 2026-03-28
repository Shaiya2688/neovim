return {

  -- Support the traditional cscope function as a backup option when LSP is not effective
  {
    "dhananjaylatkar/cscope_maps.nvim",
    dependencies = {
      -- "nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
      -- "ibhagwan/fzf-lua", -- optional [for picker="fzf-lua"]
      -- "echasnovski/mini.pick", -- optional [for picker="mini-pick"]
      -- "folke/snacks.nvim", -- optional [for picker="snacks"]
    },
    opts = {
      disable_maps = true, -- "true" disables default keymaps
      skip_input_prompt = true, -- "true" doesn't ask for input
      cscope = { -- cscope related defaults
        picker = "quickfix", -- "quickfix", "location", "telescope", "fzf-lua", "mini-pick" or "snacks"
        picker_opts = {
          window_pos = "bottom", -- "bottom", "right", "left" or "top"
        },
        skip_picker_for_single_result = false, -- "false" or "true"
        tag = { -- cstag related defaults
          keymap = false, -- "true" bind ":Cstag" to "<C-]>"
          order = { "tag" }, -- order of operation to run for ":Cstag", any combination of { "cs", "tag_picker", "tag" } (ops can be excluded)
          tag_cmd = "tjump", -- cmd to use for "tag" op in above table
        },
      },
    },
  },

}
