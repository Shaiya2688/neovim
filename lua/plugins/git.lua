return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    "lewis6991/gitsigns.nvim",
    -- See `:help gitsigns` to understand what the configuration keys do
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

        -- vim.api.nvim_set_hl

        -- hi GitGutterAdd guifg=#a3e29e guibg=#a3e29e ctermfg=157 ctermbg=157
        -- hi GitGutterAddLine guibg=#d9ffcd ctermbg=194
        -- hi GitGutterChange guifg=#c3d6e8 guibg=#c3d6e8 ctermfg=153 ctermbg=153
        -- hi GitGutterChangeLine guibg=#c3d6e8 ctermbg=153
        -- hi GitGutterDelete guifg=#ff0000 guibg=NONE ctermfg=9 ctermbg=NONE
        -- hi GitGutterDeleteLine gui=None cterm=None
        -- hi link GitGutterChangeDelete GitGutterChange
        -- hi link GitGutterChangeDeleteLine GitGutterChangeLine
        -- hi diffAdded guifg=#008000 ctermfg=28
        -- hi diffRemoved guifg=#ff0000 ctermfg=1
      end,

    },
  },

  -- TODO implement gd, gA, gl
  -- vim.keymap.set('n', 'ga', gs.diffthis, { buffer = buffer, desc = "Git Diff All Files With Staged" })
  -- vim.keymap.set('n', 'gA', function() gs.diffthis('~') end, { buffer = buffer, desc = "Git Diff All Files With 'HEAD'" })
  -- vim.keymap.set('n', 'gl', "<Cmd>Gitsigns toggle_signs<Cr>", { buffer = buffer, desc = "Git Log" })
}
