local utils = _utils
local augroup_id = vim.api.nvim_create_augroup("UserCustom", { clear = true })
-- Add any additional autocmds or remove existing autocmds here

-- Enter terminal mode automatically if terminal was opened
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = augroup_id,
  callback = function()
    if vim.opt.buftype:get() == 'terminal' and vim.fn.mode() == 'n' then
      vim.cmd("startinsert")
    end
  end,
})

-- Only highlight cursorline under active window
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = augroup_id,
  callback = function()
    vim.wo.cursorline = true
  end,
})
vim.api.nvim_create_autocmd('WinLeave', {
  group = augroup_id,
  callback = function()
    vim.wo.cursorline = false
  end,
})

-- Reset highlight groups when colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup_id,
  callback = function()
    -- highlight group for viewing 256-indexd colors
    for index = 0, 255 do
      ok, err = utils.hl.create_group(string.format("ColorView_%d", index), { fg = 0, bg = index })
      if not ok then
        vim.notify(err, vim.log.levels.ERROR)
        return
      end
    end

    -- highlight group for marked words
    utils.hl.create_group('MarkWord1',  { gui='NONE', guifg='#000000', guibg='#00ffff', cterm='NONE', ctermfg=0, ctermbg=14 })
    utils.hl.create_group('MarkWord2',  { gui='NONE', guifg='#000000', guibg='#00ff00', cterm='NONE', ctermfg=0, ctermbg=10 })
    utils.hl.create_group('MarkWord3',  { gui='NONE', guifg='#000000', guibg='#ff0000', cterm='NONE', ctermfg=0, ctermbg=9 })
    utils.hl.create_group('MarkWord4',  { gui='NONE', guifg='#000000', guibg='#ff00ff', cterm='NONE', ctermfg=0, ctermbg=13 })
    utils.hl.create_group('MarkWord5',  { gui='NONE', guifg='#000000', guibg='#ff8700', cterm='NONE', ctermfg=0, ctermbg=208 })
    utils.hl.create_group('MarkWord6',  { gui='NONE', guifg='#000000', guibg='#87af00', cterm='NONE', ctermfg=0, ctermbg=106 })
    utils.hl.create_group('MarkWord7',  { gui='NONE', guifg='#000000', guibg='#00afff', cterm='NONE', ctermfg=0, ctermbg=39 })
    utils.hl.create_group('MarkWord8',  { gui='NONE', guifg='#000000', guibg='#ffdf87', cterm='NONE', ctermfg=0, ctermbg=222 })
    utils.hl.create_group('MarkWord9',  { gui='NONE', guifg='#000000', guibg='#af5fff', cterm='NONE', ctermfg=0, ctermbg=135 })
    utils.hl.create_group('MarkWord10', { gui='NONE', guifg='#000000', guibg='#dfafdf', cterm='NONE', ctermfg=0, ctermbg=182 })
    utils.hl.create_group('MarkWord11', { gui='NONE', guifg='#000000', guibg='#87ffaf', cterm='NONE', ctermfg=0, ctermbg=121 })
    utils.hl.create_group('MarkWord12', { gui='NONE', guifg='#000000', guibg='#87afff', cterm='NONE', ctermfg=0, ctermbg=111 })
    utils.hl.create_group('MarkWord13', { gui='NONE', guifg='#000000', guibg='#008700', cterm='NONE', ctermfg=0, ctermbg=28 })
    utils.hl.create_group('MarkWord14', { gui='NONE', guifg='#000000', guibg='#5f5fff', cterm='NONE', ctermfg=0, ctermbg=63 })
    utils.hl.create_group('MarkWord15', { gui='bold', guifg='#ffffff', guibg='#800000', cterm='bold', ctermfg=255, ctermbg=1 })
    utils.hl.create_group('MarkWord16', { gui='bold', guifg='#ffffff', guibg='#008000', cterm='bold', ctermfg=255, ctermbg=2 })
    utils.hl.create_group('MarkWord17', { gui='bold', guifg='#ffffff', guibg='#808000', cterm='bold', ctermfg=255, ctermbg=3 })
    utils.hl.create_group('MarkWord18', { gui='bold', guifg='#ffffff', guibg='#000080', cterm='bold', ctermfg=255, ctermbg=4 })
    utils.hl.create_group('MarkWord19', { gui='bold', guifg='#ffffff', guibg='#800080', cterm='bold', ctermfg=255, ctermbg=5 })
    utils.hl.create_group('MarkWord20', { gui='bold', guifg='#ffffff', guibg='#008080', cterm='bold', ctermfg=255, ctermbg=6 })
    for index = 21, 50 do -- MarkWord21 ~ MarkWord50: use MarkWord20
      ok, err = utils.hl.create_group(string.format("MarkWord%d", index), { gui='bold', guifg='#ffffff', guibg='#008080', cterm='bold', ctermfg=255, ctermbg=6 })
      if not ok then
        vim.notify(err, vim.log.levels.ERROR)
        return
      end
    end

    -- highlight group for git plugins
    utils.hl.create_group('UserGitAddSigns', { guifg='#a3e29e', guibg='#a3e29e', ctermfg=157, ctermbg=157 })
    utils.hl.create_group('UserGitAddLine', { guibg='#d9ffcd', ctermbg=194 })
    utils.hl.create_group('UserGitAddLineNr', { target = 'clear' })
    utils.hl.create_group('UserGitChangeSigns', { guifg='#c3d6e8', guibg='#c3d6e8', ctermfg=153, ctermbg=153 })
    utils.hl.create_group('UserGitChangeLine', { guibg='#c3d6e8', ctermbg=153 })
    utils.hl.create_group('UserGitChangeLineNr', { target = 'clear' })
    utils.hl.create_group('UserGitDeleteSigns', { gui='bold', cterm='bold', guifg='#ff0000', ctermfg=9, bg='NONE' })
    utils.hl.create_group('UserGitDeleteLine', { target='clear' })
    utils.hl.create_group('UserGitDeleteLineNr', { target = 'clear' })
    utils.hl.create_group('UserGitChangeDeleteSigns', { target='UserGitChangeSigns' })
    utils.hl.create_group('UserGitChangeDeleteLine', { target='UserGitChangeLine' })
    utils.hl.create_group('UserGitChangeDeleteLineNr', { target = 'UserGitChangeLineNr' })
    utils.hl.create_group('UserGitStagedSigns', { guifg='#7f7f7f', ctermfg=8, bg='NONE' })
    utils.hl.create_group('UserGitStagedBoldSigns', { gui='bold', cterm='bold', guifg='#7f7f7f', ctermfg=8, bg='NONE' })
    utils.hl.create_group('UserGitStagedLine', { target = 'clear' })
    utils.hl.create_group('UserGitStagedLineNr', { target = 'clear' })
    utils.hl.create_group('UserGitPreviewAdd', { guifg='#008000', guibg='#d9ffcd', ctermfg=28, ctermbg=194 })
    utils.hl.create_group('UserGitPreviewRemoved', { guifg='#ff0000', guibg='#ffd5cc', ctermfg=1, ctermbg=225 })
  end
})
vim.api.nvim_exec_autocmds('ColorScheme', {})

-- delmarks!			"clear position of a-z marks, m{a-zA-Z} to mark position, `{a-zA-Z} or '{a-zA-Z} to jump assigned position
