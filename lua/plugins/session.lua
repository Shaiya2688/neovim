return {

  -- Support the session save and restore automatically
  {
    "rmagatti/auto-session",
    lazy = false, -- Need for session auto restore
    dependencies = {
      "nvim-telescope/telescope.nvim"
    },
    keys = {
      { '<Leader>sl', "<Cmd>AutoSession search<CR>", desc = "Session List" },
      { '<Leader>ss', function()
        local current_session = vim.v.this_session
        if current_session and current_session ~= "" then
          vim.cmd("AutoSession save")
        else
          vim.ui.input({ prompt = "Enter session name: " }, function(name)
            if name then
              -- save default name if no input
              vim.cmd("AutoSession save " .. name)
            end
          end)
        end
      end, desc = "Session Save" },
      { '<Leader>sS', function()
        vim.ui.input({ prompt = "Enter session name: " }, function(name)
          if name then
            -- save default name if no input
            vim.cmd("AutoSession save " .. name)
          end
        end)
      end, desc = "Session Save (New Name)" },
      { '<Leader>s<Space>', "<Cmd>AutoSession toggle<Cr>", desc = "Session Auto-Save Toggle" },
    },
    -- See `:h auto-session-configuration` for more help information
    opts = {
      -- Saving / restoring
      enabled = true, -- Enables/disables auto creating, saving and restoring
      auto_save = true, -- Enables/disables auto saving session on exit
      auto_restore = false, -- Enables/disables auto restoring session on start
      auto_create = true, -- Enables/disables auto creating new session files. Can be a function that returns true if a new session file should be allowed
      auto_restore_last_session = false, -- On startup, loads the last saved session if session for cwd does not exist
      cwd_change_handling = false, -- Automatically save/restore sessions when changing directories
      single_session_mode = true, -- Enable single session mode to keep all work in one session regardless of cwd changes. When enabled, prevents creation of separate sessions for different directories and maintains one unified session. Does not work with cwd_change_handling
      git_use_branch_name = false, -- Include git branch name in session name, can also be a function that takes an optional path and returns the name of the branch
      show_auto_restore_notif = true, -- Whether to show a notification when auto-restoring
      root_dir = vim.fn.stdpath("data") .. "/sessions/", -- Root dir where sessions will be stored
      -- Filtering
      suppressed_dirs = nil, -- Suppress session restore/create in certain directories
      allowed_dirs = nil, -- Allow session restore/create in certain directories
      bypass_save_filetypes = nil, -- List of filetypes to bypass auto save when the only buffer open is one of the file types listed, useful to ignore dashboards
      close_filetypes_on_save = { "checkhealth", "neo-tree", "aerial", }, -- Buffers with matching filetypes will be closed before saving
      session_lens = {
        picker = "telescope", -- "telescope"|"snacks"|"fzf"|"select"|nil Pickers are detected automatically but you can also set one manually. Falls back to vim.ui.select
        load_on_setup = true, -- Only used for telescope, registers the telescope extension at startup so you can use :Telescope session-lens
        picker_opts = { -- Table passed to Telescope / Snacks / Fzf-Lua to configure the picker
          -- For Telescopee, you can set layout_config options here:
          border = true,
          layout_strategy = 'vertical',
          layout_config = {
            width = 0.5, -- Can set width and height as percent of window
            height = 0.5,
          },
          -- For Snacks, you can set layout options here:
          -- preset = "dropdown",
          -- preview = false,
          -- layout = {
          --   width = 0.4,
          --   height = 0.4,
          -- },
          -- For Fzf-Lua, picker_opts just turns into winopts:
          -- height = 0.8,
          -- width = 0.50,
        },
        previewer = "summary", -- 'summary'|'active_buffer'|function - How to display session preview. 'summary' shows a summary of the session, 'active_buffer' shows the contents of the active buffer in the session, or a custom function
        mappings = {
          delete_session = { {'i', 'n'}, "<C-x>" }, -- mode and key for deleting a session from the picker
          alternate_session = { {'i', 'n'}, "<C-s>" }, -- mode and key for swapping to alternate session from the picker
          copy_session = { {'i', 'n'}, "<C-y>" }, -- mode and key for copying a session from the picker
        },
      },
    }
  },

}
