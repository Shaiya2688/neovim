local utils = _utils

return {

  -- Supports for file explorer, which based on filesystem, buffers and other tree like structures
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- See `:h neo-tree` for more help information
    dependencies = {
      "nvim-lua/plenary.nvim",  -- for backend utilities, such as scanning the filesystem
      "MunifTanjim/nui.nvim",   -- for all ui components, including the tree
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_fonts },  -- optional for getting pretty icons, but requires a Nerd Font.
    },
    cmd = "Neotree",
    keys = {
      { '.', function() require("neo-tree.command").execute({ toggle = true }) end, desc = "Toggle NeoTree File Explorer" },
      { '<Leader>e', function() require("neo-tree.command").execute({ action = "focus" }) end, desc = "Focus NeoTree File Explorer" },
      { '<Leader>E', function() require("neo-tree.command").execute({ action = "focus", dir=vim.fn.expand('%:p:h') }) end, desc = "Focus NeoTree File Explorer (Root Dir Switch)" },
    },
    -- Run :lua require("neo-tree").paste_default_config() to dump the fully commented default config in your current file.
    opts = {
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
      },
      source_selector = {
        winbar = true,
        statusline = false,
        sources = vim.g.have_nerd_fonts and {
          { source = "filesystem", display_name = " 󰉓 Files " },
          { source = "buffers", display_name = " 󰈚 Buffers " },
          { source = "git_status", display_name = " 󰊢 Git " },
          { source = "document_symbols", display_name = "  Symbols " },
        } or {
          { source = "filesystem", display_name = " Files " },
          { source = "buffers", display_name = " Buffers " },
          { source = "git_status", display_name = " Git " },
          { source = "document_symbols", display_name = " Symbols " },
        },
      },
      open_files_do_not_replace_types = utils.misc.merge_unique(vim.g.specially_utilized_window.fts, vim.g.specially_utilized_window.bts) or {}, -- when opening files, do not use windows containing these filetypes or buftypes
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      enable_git_status = true,
      window = {
        position = "right", -- left, right, top, bottom, float, current
        width = 48, -- applies to left and right positions
        auto_expand_width = false, -- expand the window when file exceeds the window width. does not work with position = "float"
        insert_as = "child", -- Affects how nodes get inserted into the tree during creation/pasting/moving of files if the node under the cursor is a directory:
                             -- "child":   Insert nodes as children of the directory under cursor.
                             -- "sibling": Insert nodes  as siblings of the directory under cursor.
        mappings = {
          ["."] = 'close_window',
          ["v"] = "open_vsplit",
          -- ["h"] = "open_split",
          ["s"] = "open_split",
          ["S"] = "none",
          -- ["<cr>"] = "open_drop",
          -- ["t"] = "open_tab_drop",
          ["<C-f>"] = "next_source",
          ["<C-b>"] = "prev_source",
          -- ["<"] = "none",
          -- [">"] = "none",
          -- ["<space>"] = "none", -- disable will cause the nested nodes invisible
        },
      },
      filesystem = {
        window = {
          mappings = {
            ["."] = 'close_window',
            ["r"] = { "rename", nowait=false },
            ["rt"] = "set_root",
            ["u"] = "navigate_up",
            ["gp"] = "prev_git_modified",
            ["gn"] = "next_git_modified",
            ["[g"] = "none",
            ["]g"] = "none",
          },
        },
      },
      buffers = {
        window = {
          mappings = {
            ["."] = 'close_window',
            ["bd"] = "none", -- conflicts with the default key mapping 'b'
          },
        },
      },
      git_status = {
        window = {
          mappings = {
            ["gp"] = "none", --disable git push on neovim
            ["gg"] = "none", --disable git push on neovim
          },
        },
      },
      document_symbols = {}, -- using default
      nesting_rules = {},
      default_component_configs = {
        last_modified = {
          format = "%Y-%m-%d %I:%M:%S", -- format string for timestamp (see `:h os.date()`)
        },
        created = {
          format = "%Y-%m-%d %I:%M:%S", -- format string for timestamp (see `:h os.date()`)
        },
        indent = {
          with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
          -- expander_collapsed = vim.g.have_nerd_fonts and "" or "+",
          -- expander_expanded = vim.g.have_nerd_fonts and "" or "-",
          expander_collapsed = "+",
          expander_expanded = "-",
        },
        icon = vim.g.have_nerd_fonts and {
          folder_closed = "",
          folder_open = "",
          folder_empty = "󰉖",
          folder_empty_open = "󰷏",
          -- default = "*",
          default = " ",
        } or {
          folder_closed = "▶",
          folder_open = "▼",
          folder_empty = "▷",
          folder_empty_open = "▽",
          -- default = "*",
          default = " ",
        },
        git_status = {
          symbols = {
            -- Change type
            added     = "✚", -- NOTE: you can set any of these to an empty string to not show them
            deleted   = "✖",
            modified  = "*",
            renamed   = "➜",
            -- Status type
            untracked = "?",
            -- ignored   = "!",
            ignored   = "☒",
            unstaged  = "⊹",
            staged    = "✔︎",
            conflict  = vim.g.have_nerd_fonts and "" or "✗",
          },
        },
        -- diagnostics = {
        --   symbols = {
        --     hint = "H",
        --     info = "I",
        --     warn = "!",
        --     error = "X",
        --     hint  = "➤",
        --     info  = "ℹ",
        --     warn  = "⚠",
        --     error = "✗",
        --   },
        -- },
      },
    },
  },

}
