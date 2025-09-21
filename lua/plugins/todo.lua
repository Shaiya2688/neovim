return {

  -- TODO: 1
  {
    "nvim-lualine/lualine.nvim",
	enabled = false,
  },


  -- TODO: 2
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    -- enabled = false,
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    event = "VeryLazy",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    opts_extend = { "ensure_installed" },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
    },
  },

  -- TODO: 3, "Aerial Symbol Browser",
  {
    "stevearc/aerial.nvim",
    -- event = "VeryLazy",
    keys = {
      { ",", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
    },
    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      show_guides = true,
      layout = {
        resize_to_content = false,
        win_opts = {
          winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
          signcolumn = "yes",
          statuscolumn = " ",
        },
      },
      filter_kind = false,
      -- stylua: ignore
      guides = {
        mid_item   = "├╴",
        last_item  = "└╴",
        nested_top = "│ ",
        whitespace = "  ",
      },
    },
  },

  -- TODO: 4, vim-mark
  -- TODO: 5, comment
  {
    "preservim/nerdcommenter",
    event = "VeryLazy",
    init = function()
      vim.g.NERDCreateDefaultMappings = 0
      vim.g.NERDSpaceDelims = 1				-- Add spaces after comment delimiters by default
      vim.g.NERDCompactSexyComs = 1			-- Use compact syntax for prettified multi-line comments
      vim.g.NERDDefaultAlign = 'both' 		-- Align line-wise comment delimiters flush left instead of following code indentation
      vim.g.NERDTrimTrailingWhitespace = 1	-- Enable trimming of trailing whitespace when uncommenting
      vim.g.NERDToggleCheckAllLines = 1		-- Enable NERDCommenterToggle(\c<space>) to check all selected lines is commented or not
      -- NERDLPlace="/*"						-- Specifies what to use as the left delimiter placeholder when nesting comments.
      -- NERDRPlace="*/"						-- Specifies what to use as the left delimiter placeholder when nesting comments.
    end,
    config = function()
      local opts = { noremap = true, silent = true }
      -- \ca(switch alternative delimiter),\cb(line or selected line comment),\cc(line or selected block comment),\cm(block comment use one /**/),\cu(uncomment),\cA(append comment end of line),\cs(style comment), more see :h nerdcommenter or :map
      -- vim.keymap.set({"n", "x"}, "gc", "<Plug>NERDCommenterToggle", opts)
      -- vim.keymap.set("n", "gci", "<Plug>NERDCommenterInvert", opts)

    end,
  },

}
