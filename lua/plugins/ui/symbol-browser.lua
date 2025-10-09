return {

  -- Support symbol list browser for opened buffers
  {
    "stevearc/aerial.nvim",
    -- See `:h aerial` for more help information
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_fonts },  -- optional for getting pretty icons, but requires a Nerd Font.
    },
    keys = {
      { ",", "<Cmd>AerialToggle<Cr>", desc = "Toggle Aerial (Symbol List)" },
      { "<Leader>a", function()
        local ok, aerial = pcall(require, 'aerial')
        if ok then
          if not aerial.is_open() then
            aerial.open()
          end
          aerial.focus()
        end
      end, desc = "Focus Aerial (Symbol List)" },
    },
    opts = {
      backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" }, -- Priority list of preferred backends for aerial
      layout = {
        width = nil,
        max_width = { 40, 0.2 }, -- {40, 0.2} means "the lesser of 40 columns or 20% of total"
        min_width = 25,
        win_opts = { -- add key-value pairs of window-local options for aerial window (e.g. winhl, signcolumn, statuscolumn, etc.)
        },
        default_direction = "left", -- Default direction to open the aerial window, enum: prefer_right, prefer_left, right, left, float, the 'prefer' options will open the window in the other direction *if* there is a different buffer in the way of the preferred direction
        placement = "edge", -- 'edge' or 'window': open at the far right/left of the editor, or open to the right/left of the current window
        resize_to_content = false, -- When the symbols change, resize the aerial window (within min/max constraints) to fit
        preserve_equality = false, -- Preserve window size equality with (:help CTRL-W_=)
      },
      attach_mode = "global", -- 'window' or 'global': determines aerial will display symbols for the open window or current window
      keymaps = { -- Keymaps in aerial window, set to `false` to remove a keymap
        ["?"] = "actions.show_help",
        ["g?"] = false,
        ["<CR>"] = "actions.jump",
        ["<2-LeftMouse>"] = "actions.jump",
        ["<C-v>"] = false,
        ["<C-s>"] = false,
        ["v"] = "actions.jump_vsplit",
        ["s"] = "actions.jump_split",
        ["p"] = "actions.scroll",
        ["<C-j>"] = "actions.down_and_scroll",
        ["<C-k>"] = "actions.up_and_scroll",
        ["<C-DOWN>"] = "actions.down_and_scroll",
        ["<C-UP>"] = "actions.up_and_scroll",
        ["{"] = false,
        ["}"] = false,
        ["[["] = "actions.prev_up",
        ["]]"] = "actions.next_up",
        ["q"] = "actions.close",
        ["<Space>"] = "actions.tree_toggle",
        ["o"] = "actions.tree_toggle",
        ["O"] = "actions.tree_toggle_recursive",
        ["za"] = false,
        ["zA"] = false,
        ["l"] = false,
        ["zo"] = false,
        ["L"] = false,
        ["zO"] = false,
        ["h"] = false,
        ["zc"] = false,
        ["H"] = false,
        ["zC"] = false,
        ["zr"] = "actions.tree_increase_fold_level",
        ["zR"] = "actions.tree_open_all",
        ["zm"] = "actions.tree_decrease_fold_level",
        ["zM"] = "actions.tree_close_all",
        ["zx"] = "actions.tree_sync_folds",
        ["zX"] = false,
      },
      disable_max_lines = 10000, -- Disable aerial on files with this many lines
      disable_max_size = 2000000, -- Disable aerial on files this size or larger (in bytes, default 2MB)
      filter_kind = { -- A list of all symbols to display. Set to false to display all symbols, see :h SymbolKind for all available values
        "Class",
        "Constant",
        "Constructor",
        "Enum",
        "Field",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Namespace",
        "Package",
        "Property",
        "Struct",
        "Variable",
      },
      highlight_mode = "last", -- Only the most-recently focused window will have its highlighted location marked in the aerial buffer
      highlight_on_hover = false, -- Disable highlight the symbol in the source buffer when cursor is in the aerial win
      highlight_on_jump = 300, -- When jumping to a symbol, highlight the line for this many ms, set to false to disable
      autojump = false, -- Jump to symbol in source window when the cursor moves
      icons = { -- Custom define symbol icons
        Collapsed = "+", -- use <Symbol>Collapsed to change icon for specific symbol, e.g. 'FunctionCollapsed', 'StructCollapsed'
      },
      ignore = { -- Control which windows and buffers aerial should ignore when these are focused
        unlisted_buffers = false, -- Ignore unlisted buffers. See :help buflisted
        diff_windows = true, -- Ignore diff windows
        filetypes = {}, -- List of filetypes to ignore
        buftypes = "special", -- Ignored buftypes, 'special' means all buffers other than normal, help and man page buffers are ignored
        wintypes = "special", -- Ignored wintypes, 'special' means all windows other than normal windows are ignored
      },
      nerd_font = vim.g.have_nerd_fonts, -- Set default symbol icons to use patched font icons, "auto" will set it to true if nvim-web-devicons or lspkind-nvim is installed
      open_automatic = false, -- Automatically open aerial when entering supported buffers
      post_jump_cmd = "normal! zz", -- Run this command after jumping to a symbol (false will disable)
      close_on_select = false, -- When true, aerial will automatically close after jumping to a symbol
      update_events = "TextChanged,InsertLeave", -- The autocmds that trigger symbols update (not used for LSP backend)
      show_guides = true, -- Show box drawing characters for the tree hierarchy
      guides = {
        nested_top = "│ ",
        mid_item   = "├╴", -- mid_item = "├─",
        last_item  = "└╴", -- last_item = "└─",
        whitespace = "  ",
      },
      get_highlight = function(symbol, is_icon, is_collapsed) -- Set this function to override the highlight groups for certain symbols
        -- return "MyHighlight" .. symbol.kind
      end,
    },
  },

}
