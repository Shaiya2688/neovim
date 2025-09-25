local utils = require("config.utils")

return {

  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    "lewis6991/gitsigns.nvim",
    -- See `:h gitsigns` to understand what the configuration keys do
    event = "VeryLazy",
    opts = {
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '=' },
        changedelete = { text = '~_' },
        untracked    = { text = "?" },
      },
      signs_staged = {
        add          = { text = '·' },
        change       = { text = '·' },
        delete       = { text = '·' },
        topdelete    = { text = '·' },
        changedelete = { text = '·' },
        untracked    = { text = '·' },
      },
      signs_staged_enable = true,
      signcolumn = true,
      numhl = false,
      linehl = false,
      culhl = false,
      word_diff = true,
      attach_to_untracked = true,
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        vim.keymap.set('n', 'git', gs.toggle_signs, { buffer = buffer, desc = "Git Signs Toggle" })
        vim.keymap.set('n', 'gs', gs.toggle_linehl, { buffer = buffer, desc = "Git Line Highlights Toggle" })
        vim.keymap.set('n', 'gd', function() gs.setqflist('all', { use_location_list = true, nr = 0, open = true }) end, { buffer = buffer, desc = "Git Diff All Files With Staged" }) -- TODO: auto open first item, and add to jump stack
        vim.keymap.set('n', 'gD', function() gs.setqflist('all', { use_location_list = true, nr = 0, open = true }) end, { buffer = buffer, desc = "Git Diff All Files With Staged" }) -- TODO: change to diff with HEAD
        vim.keymap.set('n', 'gb', function() gs.blame_line({ full = true, }) end, { buffer = buffer, desc = "Git Blame Line" })
        vim.keymap.set('n', 'gB', gs.blame, { buffer = buffer, desc = "Git Blame Buffer" })
        vim.keymap.set('n', 'gp', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gs.nav_hunk('prev', { target = 'unstaged', wrap = false, greedy = true, })
          end
        end, { buffer = buffer, desc = "Git Prev Hunk" })
        vim.keymap.set('n', 'gn', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gs.nav_hunk('next', { target = 'unstaged', wrap = false, greedy = true, })
          end
        end, { buffer = buffer, desc = "Git Next Hunk" })
        vim.keymap.set({'n', 'v'}, 'ghs', ":Gitsigns stage_hunk<Cr>", { buffer = buffer, desc = "Git Stage Hunk (see git-add)" })
        vim.keymap.set('n', 'ghr', ":Gitsigns stage_hunk<Cr>", { buffer = buffer, desc = "Git Reset/Unstage Hunk (see git-reset)" })
        vim.keymap.set({'n', 'v'}, 'ghu', ":Gitsigns reset_hunk<Cr>", { buffer = buffer, desc = "Git Undo Hunk (see git-checkout)" })
        vim.keymap.set('n', 'ghS', gs.stage_buffer, { buffer = buffer, desc = "Git Stage All Hunks (see git-add)" })
        vim.keymap.set('n', 'ghR', gs.reset_buffer_index, { buffer = buffer, desc = "Git Reset/Unstage All Hunks (see git-reset)" })
        vim.keymap.set('n', 'ghU', gs.reset_buffer, { buffer = buffer, desc = "Git Undo All Hunks (see git-checkout)" })
        local toggle_diffthis = function(ui_entry)
          local close = false
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_is_valid(win) and vim.api.nvim_get_option_value('diff', { win = win }) then
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.b[buf].is_gitsigns_diff then
                vim.b[buf].is_gitsigns_diff = nil
                vim.api.nvim_win_close(win, false)
                close = true
              end
            end
          end

          if not close then
            local new_win, new_buf = utils.ui.new_win_buf(ui_entry)
            if new_win and new_buf and vim.api.nvim_win_is_valid(new_win) and vim.api.nvim_win_get_buf(new_win) == new_buf
              and vim.api.nvim_get_option_value('diff', { win = new_win }) and vim.api.nvim_get_current_win() ~= new_win then
              vim.api.nvim_set_current_win(new_win)
              vim.b[new_buf].is_gitsigns_diff = true
            end
          end
        end
        local diff_stage = function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_is_valid(win) and vim.api.nvim_get_option_value('diff', { win = win }) then
              local buf = vim.api.nvim_win_get_buf(win)
              if not vim.b[buf].is_gitsigns_diff then
                vim.api.nvim_set_option_value('diff', false, { win = win })
              end
            end
          end
          gs.diffthis()
          -- wait for 100ms until diff window ready
          vim.wait(100, function()
            for _, w in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_get_option_value('diff', { win = w }) then
                return true
              end
            end
          end, 10)
        end
        local diff_head = function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_is_valid(win) and vim.api.nvim_get_option_value('diff', { win = win }) then
              local buf = vim.api.nvim_win_get_buf(win)
              if not vim.b[buf].is_gitsigns_diff then
                vim.api.nvim_set_option_value('diff', false, { win = win })
              end
            end
          end
          gs.diffthis('HEAD')
          -- wait for 100ms until diff window ready
          vim.wait(100, function()
            for _, w in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_get_option_value('diff', { win = w }) then
                return true
              end
            end
          end, 10)
        end
        vim.keymap.set('n', 'ghd', function() toggle_diffthis(diff_stage) end, { buffer = buffer, desc = "Git Diff All Hunks With Staged" })
        vim.keymap.set('n', 'ghD', function() toggle_diffthis(diff_head) end, { buffer = buffer, desc = "Git Diff All Hunks With 'HEAD'" })
        vim.keymap.set('n', 'ghp', function()
          gs.preview_hunk()
          gs.preview_hunk() -- auto focus the preview windos
        end, { buffer = buffer, desc = "Git Hunks Preview" })
      end,
    },

    config = function(_, opts)
      local highlight_setup = function()
        utils.hl.create_group('GitSignsAdd', { target='UserGitAddSigns' })
        utils.hl.create_group('GitSignsAddNr', { target='UserGitAddLineNr' })
        utils.hl.create_group('GitSignsAddLn', { target='UserGitAddLine' })
        utils.hl.create_group('GitSignsChange', { target='UserGitChangeSigns' })
        utils.hl.create_group('GitSignsChangeNr', { target='UserGitChangeLineNr' })
        utils.hl.create_group('GitSignsChangeLn', { target='UserGitChangeLine' })
        utils.hl.create_group('GitSignsDelete', { target='UserGitDeleteSigns' })
        utils.hl.create_group('GitSignsDeleteNr', { target='UserGitDeleteLineNr' })
        utils.hl.create_group('GitSignsDeleteLn', { target='UserGitDeleteLine' })
        utils.hl.create_group('GitSignsChangedelete', { target='UserGitChangeDeleteSigns' })
        utils.hl.create_group('GitSignsChangedeleteNr', { target='UserGitChangeDeleteLineNr' })
        utils.hl.create_group('GitSignsChangedeleteLn', { target='UserGitChangeDeleteLine' })
        utils.hl.create_group('GitSignsStagedAdd', { target='UserGitStagedSigns' })
        utils.hl.create_group('GitSignsStagedAddNr', { target='UserGitAddLineNr' })
        utils.hl.create_group('GitSignsStagedAddLn', { target='UserGitStagedLine' })
        utils.hl.create_group('GitSignsStagedChange', { target='UserGitStagedSigns' })
        utils.hl.create_group('GitSignsStagedChangeNr', { target='UserGitChangeLineNr' })
        utils.hl.create_group('GitSignsStagedChangeLn', { target='UserGitStagedLine' })
        utils.hl.create_group('GitSignsStagedDelete', { target='UserGitStagedBoldSigns' })
        utils.hl.create_group('GitSignsStagedDeleteNr', { target='UserGitDeleteLineNr' })
        utils.hl.create_group('GitSignsStagedChangedelete', { target='UserGitStagedSigns' })
        utils.hl.create_group('GitSignsStagedChangedeleteNr', { target='UserGitChangeDeleteLineNr' })
        utils.hl.create_group('GitSignsStagedChangedeleteLn', { target='UserGitStagedLine' })
        utils.hl.create_group('GitSignsStagedTopdelete', { target='UserGitStagedBoldSigns' })
        utils.hl.create_group('GitSignsStagedTopdeleteNr', { target='UserGitDeleteLineNr' })
        utils.hl.create_group('GitSignsStagedTopdeleteLn', { target='UserGitStagedLine' })
        utils.hl.create_group('GitSignsStagedUntracked', { target='UserGitStagedSigns' })
        utils.hl.create_group('GitSignsStagedUntrackedNr', { target='UserGitAddLineNr' })
        utils.hl.create_group('GitSignsStagedUntrackedLn', { target='UserGitStagedLine' })
        utils.hl.create_group('GitSignsAddPreview', { target='UserGitPreviewAdd' })
        utils.hl.create_group('GitSignsDeletePreview', { target='UserGitPreviewRemoved' })
      end

      -- Reset highlight groups when colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("CustomGitSignsHighlight", { clear = true }),
        callback = highlight_setup,
      })

      local ok, gs = pcall(require, 'gitsigns')
      if ok then
        gs.setup(opts)
        highlight_setup()
      end
    end
  },

  -- TODO git log(gl), and hunk fold (ghf)
  -- vim.keymap.set('n', 'gl', "<Cmd>Gitsigns toggle_signs<Cr>", { buffer = buffer, desc = "Git Log" })

}
