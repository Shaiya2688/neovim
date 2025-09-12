local utils = require("config.utils")
local augroup_id = vim.api.nvim_create_augroup("UserCustom", { clear = true })
local aucmd_id
-- Add any additional autocmds or remove existing autocmds here

-- Enter terminal mode automatically if terminal was opened
aucmd_id = vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = augroup_id,
  callback = function()
    if vim.opt.buftype:get() == 'terminal' and vim.fn.mode() == 'n' then
      vim.cmd("startinsert")
    end
  end,
})

-- Reset highlight groups when colorscheme changes
aucmd_id = vim.api.nvim_create_autocmd("ColorScheme", {
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
    utils.hl.create_group('MarkWord1',  { gui='None', guifg='#000000', guibg='#00ffff', cterm='None', ctermfg=0, ctermbg=14 })
    utils.hl.create_group('MarkWord2',  { gui='None', guifg='#000000', guibg='#00ff00', cterm='None', ctermfg=0, ctermbg=10 })
    utils.hl.create_group('MarkWord3',  { gui='None', guifg='#000000', guibg='#ff0000', cterm='None', ctermfg=0, ctermbg=9 })
    utils.hl.create_group('MarkWord4',  { gui='None', guifg='#000000', guibg='#ff00ff', cterm='None', ctermfg=0, ctermbg=13 })
    utils.hl.create_group('MarkWord5',  { gui='None', guifg='#000000', guibg='#ff8700', cterm='None', ctermfg=0, ctermbg=208 })
    utils.hl.create_group('MarkWord6',  { gui='None', guifg='#000000', guibg='#87af00', cterm='None', ctermfg=0, ctermbg=106 })
    utils.hl.create_group('MarkWord7',  { gui='None', guifg='#000000', guibg='#00afff', cterm='None', ctermfg=0, ctermbg=39 })
    utils.hl.create_group('MarkWord8',  { gui='None', guifg='#000000', guibg='#ffdf87', cterm='None', ctermfg=0, ctermbg=222 })
    utils.hl.create_group('MarkWord9',  { gui='None', guifg='#000000', guibg='#af5fff', cterm='None', ctermfg=0, ctermbg=135 })
    utils.hl.create_group('MarkWord10', { gui='None', guifg='#000000', guibg='#dfafdf', cterm='None', ctermfg=0, ctermbg=182 })
    utils.hl.create_group('MarkWord11', { gui='None', guifg='#000000', guibg='#87ffaf', cterm='None', ctermfg=0, ctermbg=121 })
    utils.hl.create_group('MarkWord12', { gui='None', guifg='#000000', guibg='#87afff', cterm='None', ctermfg=0, ctermbg=111 })
    utils.hl.create_group('MarkWord13', { gui='None', guifg='#000000', guibg='#008700', cterm='None', ctermfg=0, ctermbg=28 })
    utils.hl.create_group('MarkWord14', { gui='None', guifg='#000000', guibg='#5f5fff', cterm='None', ctermfg=0, ctermbg=63 })
    utils.hl.create_group('MarkWord15', { gui='bold', guifg='#ffffff', guibg='#800000', cterm='bold', ctermfg=255, ctermbg=1 })
    utils.hl.create_group('MarkWord16', { gui='bold', guifg='#ffffff', guibg='#008000', cterm='bold', ctermfg=255, ctermbg=2 })
    utils.hl.create_group('MarkWord17', { gui='bold', guifg='#ffffff', guibg='#808000', cterm='bold', ctermfg=255, ctermbg=3 })
    utils.hl.create_group('MarkWord18', { gui='bold', guifg='#ffffff', guibg='#000080', cterm='bold', ctermfg=255, ctermbg=4 })
    utils.hl.create_group('MarkWord19', { gui='bold', guifg='#ffffff', guibg='#800080', cterm='bold', ctermfg=255, ctermbg=5 })
    utils.hl.create_group('MarkWord20', { gui='bold', guifg='#ffffff', guibg='#008080', cterm='bold', ctermfg=255, ctermbg=6 })
    for index = 21, 50 do -- use MarkWord20
      ok, err = utils.hl.create_group(string.format("MarkWord%d", index), { gui='bold', guifg='#ffffff', guibg='#008080', cterm='bold', ctermfg=255, ctermbg=6 })
      if not ok then
        vim.notify(err, vim.log.levels.ERROR)
        return
      end
    end

    -- highlight group for git gutter
    utils.hl.create_group('GitGutterAdd', { guifg='#a3e29e', guibg='#a3e29e', ctermfg=157, ctermbg=157 })
    utils.hl.create_group('GitGutterAddLine', { guibg='#d9ffcd', ctermbg=194 })
    utils.hl.create_group('GitGutterChange', { guifg='#c3d6e8', guibg=#c3d6e8, ctermfg=153, ctermbg=153 })
    utils.hl.create_group('GitGutterChangeLine', { guibg='#c3d6e8', ctermbg=153 })
    utils.hl.create_group('GitGutterDelete', { guifg='#ff0000', guibg=NONE, ctermfg=9, ctermbg=NONE })
    utils.hl.create_group('GitGutterDeleteLine', { gui=None, cterm=None })
    -- hi, link, GitGutterChangeDelete, GitGutterChange
    -- hi, link, GitGutterChangeDeleteLine, GitGutterChangeLine
    utils.hl.create_group('diffAdded', { guifg='#008000', ctermfg=28 })
    utils.hl.create_group('diffRemoved', { guifg='#ff0000', ctermfg=1 })


  end,
})

-- delmarks!			"clear position of a-z marks, m{a-zA-Z} to mark position, `{a-zA-Z} or '{a-zA-Z} to jump assigned position
