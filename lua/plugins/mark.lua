return {

  -- Highlight several words in different colors simultaneously
  {
    "inkarkat/vim-mark",
    -- See `:h mark.vim` for more help information
    dependencies = {
      "inkarkat/vim-ingo-library",
    },
    init = function()
      vim.g.mw_no_mappings = 1
      vim.g.mwAutoSaveMarks = 1
      -- Enable save and restore global variables for g:MARK_[name], which will be used for Mark-Words saving, default name is MARKS
      vim.opt.shada:prepend('!')
      vim.opt.sessionoptions:append('globals')
    end,
    config = function()
      vim.keymap.set({ 'n', 'x' }, '<Leader>mm', "<Plug>MarkSet", { desc = "Highlight Mark-Words" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>mr', "<Plug>MarkRegex", { desc = "Highlight Mark-Words by Regex" })
      vim.keymap.set('n', '<Leader>mt', "<Plug>MarkToggle", { desc = "Toggle All Highlight Mark-Words" })
      vim.keymap.set('n', '<Leader>mc', "<Plug>MarkConfirmAllClear", { desc = "Confirm Clear All Highlight Mark-Words" })
      vim.keymap.set('n', '<Leader>mC', "<Plug>MarkAllClear", { desc = "Clear All Highlight Mark-Words" })
      vim.keymap.set('n', '<Leader>ms', function()
        if not vim.fn.exists('*mark#GetCount') or (vim.fn['mark#GetCount']() <= 0) then
          vim.notify("No Mark-Words to Saving...", vim.log.levels.ERROR)
        else
          local name = vim.fn.input("Save Name: ")
          if name ~= '' then
            vim.fn.execute('MarkSave ' .. name)
            vim.cmd.wshada()  -- TODO: enable save by set shadafile or use shared temp file for this plugin
            if vim.g['MARK_' .. name] and type(vim.g['MARK_' .. name]) == 'string' then
              vim.notify("[\'" .. name .."\'] Mark-Words " .. vim.g[ 'MARK_' .. name ], vim.log.levels.INFO)
            else
              vim.notify("Mark-Words Saving Failed", vim.log.levels.ERROR)
            end
          end
        end
      end, { desc = "Save Highlight Mark-Words" })
      vim.keymap.set('n', '<Leader>ml', function()
        local name = vim.fn.input("Loading By Name: ")
        if name ~= '' then
          vim.cmd.rshada()
          if vim.g['MARK_' .. name] and type(vim.g['MARK_' .. name]) == 'string' then
            vim.fn.execute('MarkLoad ' .. name)
            vim.notify("[\'" .. name .."\'] Mark-Words " .. vim.g[ 'MARK_' .. name ], vim.log.levels.INFO)
          else
            vim.notify("\nNo records for \'" .. name .. "\'", vim.log.levels.ERROR)
          end
        end
      end, { desc = "Load Highlight Mark-Words" })
      vim.keymap.set('n', '<Leader>mn', "<Plug>MarkSearchCurrentNext", { desc = "Search Current Highlight Mark-Words" })
      vim.keymap.set('n', '<Leader>mN', "<Plug>MarkSearchCurrentPrev", { desc = "Search Current Highlight Mark-Words" })
      vim.keymap.set('n', '<Leader>/', "<Plug>MarkSearchAnyNext", { desc = "Search Any Highlight Mark-Words" })
      vim.keymap.set('n', '<Leader>?', "<Plug>MarkSearchAnyPrev", { desc = "Search Any Highlight Mark-Words" })
      vim.keymap.set('n', '<Leader>mv', "<Cmd>Marks<Cr>", { desc = "View All Highlight Mark-Words" })
    end,
  },

}
