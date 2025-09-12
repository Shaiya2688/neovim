local utils = require("config.utils")

return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    "lewis6991/gitsigns.nvim",
    -- See `:help gitsigns` to understand what the configuration keys do
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
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '=' },
        changedelete = { text = '~_' },
        untracked    = { text = '?' },
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
        vim.keymap.set('n', 'git', function() gs.toggle_signs() end, { buffer = buffer, desc = "Git Signs Toggle" })
        vim.keymap.set('n', 'gs', function() gs.toggle_linehl() end, { buffer = buffer, desc = "Git Line Highlights Toggle" })
        vim.keymap.set('n', 'gd', gs.diffthis, { buffer = buffer, desc = "Git Diff With Staged" })
        vim.keymap.set('n', 'gD', function() gs.diffthis('HEAD') end, { buffer = buffer, desc = "Git Diff With 'HEAD'" })
        vim.keymap.set('n', 'gb', function() gs.blame_line({ full = true, }) end, { buffer = buffer, desc = "Git Blame Line" })
        vim.keymap.set('n', 'gB', function() gs.blame() end, { buffer = buffer, desc = "Git Blame Buffer" })
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

      require('gitsigns').setup(opts)
      highlight_setup()
    end
  },

  -- TODO support ga, gA, gl
  -- vim.keymap.set('n', 'ga', gs.diffthis, { buffer = buffer, desc = "Git Diff All Files With Staged" })
  -- vim.keymap.set('n', 'gA', function() gs.diffthis('~') end, { buffer = buffer, desc = "Git Diff All Files With 'HEAD'" })
  -- vim.keymap.set('n', 'gl', "<Cmd>Gitsigns toggle_signs<Cr>", { buffer = buffer, desc = "Git Log" })
}
