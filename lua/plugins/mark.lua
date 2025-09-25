local utils = require("config.utils")

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
    end,
    config = function()
      vim.keymap.set({ 'n', 'x' }, '<Leader>mm', "<Plug>MarkSet", { desc = "Mark Words With Highlight" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>mr', "<Plug>MarkRegex", { desc = "Mark Words (Using Regex) With Highlight" })
      vim.keymap.set('n', '<Leader>mc', "<Plug>MarkAllClear", { desc = "Clear All Mark Words" })
      vim.keymap.set('n', '<Leader>mC', "<Plug>MarkConfirmAllClear", { desc = "Clear All Mark Words With Confirm" })
      vim.keymap.set('n', '<Leader>mt', "<Plug>MarkToggle", { desc = "Toggle Highlight For All Mark Words" })
      vim.keymap.set('n', '<Leader>ms', function()
        if not vim.fn.exists('*mark#GetCount') or (vim.fn['mark#GetCount']() <= 0) then
          vim.notify("No marked words", vim.log.levels.ERROR)
        else
          local name = vim.fn.input("> Enter save name: ")
          vim.cmd('echo ""')
          if name ~= '' then
            vim.fn.execute('MarkSave ' .. name)
            if type(vim.g['MARK_' .. name]) == 'string' then
              utils.file.set_persist_var(name, vim.g['MARK_' .. name])
              vim.notify("[\'" .. name .."\'] saved, marked words: " .. utils.file.get_persist_var(name, "nil"), vim.log.levels.INFO)
            else
              vim.notify("Mark words saving fail", vim.log.levels.ERROR)
            end
          end
        end
      end, { desc = "Save Mark Words" })
      vim.keymap.set('n', '<Leader>ml', function()
        local name = vim.fn.input("> Loading name: ")
        vim.cmd('echo ""')
        if name ~= '' then
          local pattern = utils.file.get_persist_var(name, nil)
          if type(pattern) == 'string' then
            vim.g['MARK_' .. name] = pattern
            vim.fn.execute('MarkLoad ' .. name)
            vim.notify("[\'" .. name .."\'] loaded, marked words: " .. pattern, vim.log.levels.INFO)
          else
            vim.notify("No marked words for \'" .. name .. "\'", vim.log.levels.ERROR)
          end
        end
      end, { desc = "Load Mark Words" })
      vim.keymap.set('n', '<Leader>mn', "<Plug>MarkSearchCurrentNext", { desc = "Search Next Current Mark Word" })
      vim.keymap.set('n', '<Leader>mN', "<Plug>MarkSearchCurrentPrev", { desc = "Search Prev Current Mark Word" })
      vim.keymap.set('n', '<Leader>/', "<Plug>MarkSearchAnyNext", { desc = "Search Next Any Mark Words" })
      vim.keymap.set('n', '<Leader>?', "<Plug>MarkSearchAnyPrev", { desc = "Search Prev Any Mark Words" })
      vim.keymap.set('n', '<Leader>mv', "<Cmd>Marks<Cr>", { desc = "View All Mark Words" })
    end,
  },

}
