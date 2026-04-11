local utils = _utils

return {

  -- Support for fuzzy finding
  {
    -- See `:h telescope` for more help information
    'nvim-telescope/telescope.nvim', version = '*',
    event = "VeryLazy",
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- optional but recommended
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_fonts },  -- optional for getting pretty icons, but requires a Nerd Font.
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-live-grep-args.nvim', version = '^1.0.0' },
    },
    config = function()
      local ok, telescope, builtin, state, actions, actions_generate, actions_layout, actions_lga = pcall(function()
        return
        require('telescope'),
        require('telescope.builtin'),
        require('telescope.state'),
        require('telescope.actions'),
        require('telescope.actions.generate'),
        require("telescope.actions.layout"),
        require("telescope-live-grep-args.actions")
      end)
      if not ok then return end
      telescope.setup({
        defaults = {
          prompt_prefix = vim.g.have_nerd_fonts and '🔍 ' or '> ',
          selection_caret = vim.g.have_nerd_fonts and '❯ ' or '> ',
          entry_prefix = '  ',
          path_display = {
            -- truncate = 0,
            -- tail = {},
          },
          dynamic_preview_title = true,
          sorting_strategy = "ascending", -- "descending" moves the cursor upwards, otherwise "ascending".
          winblend = 0,
          preview = {
            -- check_mime_type = true,
            filesize_limit = 5, -- 25MB
            highlight_limit = 1, -- 1MB
            timeout = 500, -- 250ms
          },
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              width = 0.85, -- 0.8
              height = 0.95, -- 0.9
              preview_width = 0.55,
              -- preview_cutoff = 120,
              prompt_position = "bottom",
            },
            vertical = {
              width = 0.8,
              height = 0.95, -- 0.9
              preview_height = 0.55,
              preview_cutoff = 0,
              prompt_position = "top", -- bottom
              mirror = false,
            },
            cursor = {
              width = 0.85,
              height = 0.95,
              preview_width = 0.55,
            },
          },
          cycle_layout_list = { "vertical", "horizontal", },
          file_ignore_patterns = {
            ".*cscope%..*",
            ".*tags",
            "^%.git/"
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            -- "--trim",
            "--no-ignore",
          },
          mappings = {
            i = {
              -- actions.which_key shows the mappings for your picker,
              -- Map actions.which_key to <C-?><C-/>
              ['<C-?>'] = actions_generate.which_key {
                max_height = 0.4, -- 0.4
                keybind_width = 15, -- 7
                name_width = 40, -- 30
                winblend = 5,
              },
              ['<C-/>'] = actions_generate.which_key {
                max_height = 0.4, -- 0.4
                keybind_width = 15, -- 7
                name_width = 40, -- 30
                winblend = 5,
              },
              ['<C-_>'] = actions_generate.which_key { -- link to <C-/> for some terminal
                max_height = 0.4, -- 0.4
                keybind_width = 15, -- 7
                name_width = 40, -- 30
                winblend = 5,
              },
              ['<C-n>'] = actions_layout.cycle_layout_next,
              ['<C-x>'] = false,
              ['<C-s>'] = "select_horizontal",
              ['<A-p>'] = actions_layout.toggle_preview,
              ['<C-q>'] = false,
              ['<Leader><C-q>'] = actions.send_to_qflist + actions.open_qflist,
            },
            n = {
              -- actions.which_key shows the mappings for your picker,
              -- Map actions.which_key to ?,<C-?><C-/>
              ['?'] = actions_generate.which_key {
                max_height = 0.4, -- 0.4
                keybind_width = 15, -- 7
                name_width = 40, -- 30
                winblend = 5,
              },
              ['<C-?>'] = actions_generate.which_key {
                max_height = 0.4, -- 0.4
                keybind_width = 15, -- 7
                name_width = 40, -- 30
                winblend = 5,
              },
              ['<C-/>'] = actions_generate.which_key {
                max_height = 0.4, -- 0.4
                keybind_width = 15, -- 7
                name_width = 40, -- 30
                winblend = 5,
              },
              ['<C-_>'] = actions_generate.which_key { -- link to <C-/> for some terminal
                max_height = 0.4, -- 0.4
                keybind_width = 15, -- 7
                name_width = 40, -- 30
                winblend = 5,
              },
              ['<C-c>'] = "close",
              ['<C-x>'] = false,
              ['<C-s>'] = "select_horizontal",
              ['<A-p>'] = actions_layout.toggle_preview,
              ['<C-q>'] = false,
              ['<Leader><C-q>'] = actions.send_to_qflist + actions.open_qflist,
            },
          },
        },
        pickers = {
          find_files = {
            previewer = false, -- disable preview to speed up file search, use <A-p> to toggle preview
            no_ignore = true,
            no_ignore_parent = true,
            -- find_command = function()
            --   if 1 == vim.fn.executable("rg") then
            --     return { "rg", "--files", "--color", "never", "-g", "!.git" }
            --   elseif 1 == vim.fn.executable("fd") then
            --     return { "fd", "--type", "f", "--strip-cwd-prefix", "--color", "never", "-E", ".git" }
            --   elseif 1 == vim.fn.executable("fdfind") then
            --     return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
            --   elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
            --     return { "find", ".", "-type", "f" }
            --   elseif 1 == vim.fn.executable("where") then
            --     return { "where", "/r", ".", "*" }
            --   end
            -- end,
          },
          buffers = {
            previewer = false, -- disable preview to speed up file search, use <A-p> to toggle preview
            sort_mru = true,
            sort_lastused = true,
            ignore_current_buffer = true,
            mappings = {
              i = {
                ['<C-x>'] = actions.delete_buffer,
              },
              n = {
                ['<C-x>'] = actions.delete_buffer,
              },
            },
          },
        },
        live_grep = {
          only_sort_text = true,
          -- file_ignore_patterns = { 'node_modules', '.git/' },
        },
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- "smart_case" or "ignore_case" or "respect_case"
          },
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            mappings = {
              i = {
                ['<C-a>'] = actions_lga.quote_prompt(),
                ['<C-i>'] = actions_lga.quote_prompt({ postfix = " --iglob " }),
                -- ['<C-t>'] = actions_lga.quote_prompt({ postfix = " -t " }),
                -- freeze the current list and start a fuzzy search in the frozen list
                -- ['<C-space>'] = actions_lga.to_fuzzy_refine,
              },
            },
          },
        },
      })
      -- load_extension
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'live_grep_args')
      -- autocmd
      vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopePreviewerLoaded",
        callback = function(args)
          if args.data.filetype ~= "help" then
            vim.wo.number = true
          end
          vim.wo.wrap = false
        end,
      })
      -- keymaps: picker
      vim.keymap.set('n', '<Leader>f?', builtin.builtin, { desc = "Choose an Builtin Picker to Find" })
      vim.keymap.set('n', '<Leader>f/', builtin.builtin, { desc = "Choose an Builtin Picker to Find" })
      vim.keymap.set('n', '<Leader>f<Space>', function()
          local cached_pickers = state.get_global_key('cached_pickers') or {}
          if #cached_pickers > 0 then
              builtin.resume()
          else
              builtin.builtin()
          end
      end, { desc = "Toggle Picker" })
      -- keymaps: find file
      vim.keymap.set('n', '<Leader>ff', function()
        builtin.find_files({
          cwd = utils.file.workspace_root(),
        })
      end, { desc = "Find Files (Workspace)" })
      vim.keymap.set('n', '<Leader>f<C-f>', function()
        builtin.find_files({
          cwd = utils.file.local_root(),
        })
      end, { desc = "Find Files (Local)" })
      vim.keymap.set('n', '<Leader>fF', function()
        builtin.find_files({
          cwd = utils.file.project_root(),
        })
      end, { desc = "Find Files (Project)" })
      vim.keymap.set('n', '<Leader>fg', builtin.git_files, { desc = "Find Files (Git)" })
      vim.keymap.set('n', '<Leader>fb', builtin.buffers, { desc = "Find Buffers" })
      vim.keymap.set('n', '<Leader>fo', builtin.oldfiles, { desc = "Find Old Files" })
      vim.keymap.set('n', '<Leader>fc', function()
        builtin.find_files({
          cwd = vim.fn.stdpath('config'),
        })
      end, { desc = "Find Config Files" })
      -- keymaps: find pattern
      vim.keymap.set('n', '<Leader>fs', function()
        builtin.live_grep({
          cwd = utils.file.workspace_root(),
          use_regex = true,
        })
      end, { desc = "Live Grep String (Workspace)" })
      vim.keymap.set('n', '<Leader>f<C-s>', function()
        builtin.live_grep({
          cwd = utils.file.local_root(),
          use_regex = true,
        })
      end, { desc = "Live Grep String (Local)" })
      vim.keymap.set('n', '<Leader>fS', function()
        builtin.live_grep({
          cwd = utils.file.project_root(),
          use_regex = true,
        })
      end, { desc = "Live Grep String (Project)" })
      vim.keymap.set('n', '<Leader>fa', function()
        telescope.extensions.live_grep_args.live_grep_args({
          cwd = utils.file.workspace_root(),
          use_regex = true,
        })
      end, { desc = "Live Grep String with Args (Workspace)" })
      vim.keymap.set('n', '<Leader>f<C-a>', function()
        telescope.extensions.live_grep_args.live_grep_args({
          cwd = utils.file.local_root(),
          use_regex = true,
        })
      end, { desc = "Live Grep String with Args (Local)" })
      vim.keymap.set('n', '<Leader>fA', function()
        telescope.extensions.live_grep_args.live_grep_args({
          cwd = utils.file.project_root(),
          use_regex = true,
        })
      end, { desc = "Live Grep String with Args (Project)" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fw', function()
        builtin.grep_string({
          cwd = utils.file.workspace_root(),
          additional_args = {
            "--case-sensitive",
          },
        })
      end, { desc = "Grep Word Under Cursor or Visual Selection (Workspace)" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>f<C-w>', function()
        builtin.grep_string({
          cwd = utils.file.local_root(),
          additional_args = {
            "--case-sensitive",
          },
        })
      end, { desc = "Grep Word Under Cursor or Visual Selection (Local)" })
      vim.keymap.set({ 'n', 'v' }, '<Leader>fW', function()
        builtin.grep_string({
          cwd = utils.file.project_root(),
          additional_args = {
            "--case-sensitive",
          },
        })
      end, { desc = "Grep Word Under Cursor or Visual Selection (Project)" })
      -- keymaps: git, check gitsigns.nvim for more git keymaps
      vim.keymap.set('n', 'gl', builtin.git_bcommits, { desc = "Git Commits Log (Buffer)" })
      vim.keymap.set('n', 'gL', builtin.git_commits, { desc = "Git Commits Log (All)" })
      vim.keymap.set('n', 'gD', builtin.git_status, { desc = "Git Diff All Files With HEAD" })
      -- keymaps: quickfix, locationlist, diagnostics
      vim.keymap.set('n', '<Leader>fq', builtin.quickfix, { desc = "Open Quickfix" })
      vim.keymap.set('n', '<Leader>fl', builtin.loclist, { desc = "Open Location List" })
      vim.keymap.set('n', '<Leader>fd', function()
        builtin.diagnostics({
          bufnr = 0,
        })
      end, { desc = "Open Diagnostics (Buffer)" })
      vim.keymap.set('n', '<Leader>fD', builtin.diagnostics, { desc = "Open Diagnostics" })
      -- keymaps: jumplist (<C-i>/<C-o>), marks (m{a-z,A-Z,0-9,...})
      vim.keymap.set('n', '<Leader>fj', builtin.jumplist, { desc = "Open Jump List (<C-i>/<C-o>)" })
      vim.keymap.set('n', '<Leader>fm', builtin.marks, { desc = "Open Mark List (\'{a-z,A-Z,0-9,...})" })
      -- TODO: for LSP
    end,
  },

}
