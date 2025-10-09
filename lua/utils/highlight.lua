--[[ Utils for Highlight ]]
local M = {}

function M.setup()
  --[[ The following (case-insensitive) names are recognized for cterm colors
  NR      COLOR NAME
  0       Black
  1       DarkRed
  2       DarkGreen
  3       Brown, DarkYellow
  4       DarkBlue
  5       DarkMagenta
  6       DarkCyan
  7       LightGray, LightGrey, Gray, Grey
  8       DarkGray, DarkGrey
  9       Red, LightRed
  10      Green, LightGreen
  11      Yellow, LightYellow
  12      Blue, LightBlue
  13      Magenta, LightMagenta
  14      Cyan, LightCyan
  15      White ]]
  M.default_terminal_ansi_colors = {
    '#000000', '#cd0000', '#00cd00', '#ffaf00', '#5454ff', '#cd00cd',  '#00cdcd', '#d7d7d7',
    '#7f7f7f', '#ff0000', '#00ff00', '#ffff00', '#00afff', '#ff00ff',  '#00ffff', '#ffffff'
  }
  M.colorscheme_augroup = vim.api.nvim_create_augroup("UserCustomColorScheme", { clear = true })
end

function M.color_index2rgb(idx)
  if idx == nil or type(idx) ~= 'number' or idx < 0 or idx > 255 then
    return '#000000'
  end

  local function clamp(x, min, max)
    return math.floor(math.max(min, math.min(max, x)))
  end

  idx = clamp(idx, 0, 255)

  -- 0-15 ansi colors:
  if idx < 16 then
    if vim.g.terminal_ansi_colors ~= nil and type(vim.g.terminal_ansi_colors) == 'table' and #vim.g.terminal_ansi_colors == 16 then
      local color = vim.g.terminal_ansi_colors[idx + 1]
      if type(color) == 'string' and color:match('^#%x%x%x%x%x%x$') then
        return color
      end
    end
    return M.default_terminal_ansi_colors[idx + 1]
  end

  -- 232-255 gray colors:
  if idx >= 232 then
    local gray = 8 + (idx - 232) * 10
    return string.format('#%02x%02x%02x', gray, gray, gray)
  end

  -- -- 16-231 6x6x6 cube:
  idx = idx - 16
  local map = { 0, 95, 135, 175, 215, 255 }
  local r = clamp(idx / 36, 0, 5)
  local g = clamp((idx % 36) / 6, 0, 5)
  local b = clamp(idx % 6, 0, 5)
  return string.format('#%02x%02x%02x', map[r + 1], map[g + 1], map[b + 1])
end

-- Parameters:
--   name:      string: group name
--   {opts}:    table, include additional options:
--   fg:        integer: 0-255, or string: 'NONE' (optional), both ctermfg and guifg will be affect
--   bg:        integer: 0-255, or string: 'NONE' (optional), both ctermbg and guibg will be affect
--   cterm:     string (optional)
--   ctermfg:   integer: 0-255, or string: 'fg', 'bg', 'NONE' (optional)
--   ctermbg:   integer: 0-255, or string: 'fg', 'bg', 'NONE' (optional)
--   gui:       string (optional)
--   guifg:     string: '#RRGGBB', 'fg', 'bg', 'NONE' (optional)
--   guibg:     string: '#RRGGBB', 'fg', 'bg', 'NONE' (optional)
--   target:    string: 'clear', 'NONE', or target group name (optional)
-- And at least one option must be included
function M.create_group(name, opts)
  if name == nil or type(name) ~= 'string' then
    return nil, "[utils.highlight.set] invalid name"
  end

  if opts == nil or type(opts) ~= 'table' then
    return nil, "[utils.highlight.set] invalid option"
  end

  local cterm, gui, fg, bg, ctermfg, ctermbg, guifg, guibg, target = opts.cterm, opts.gui, opts.fg, opts.bg, opts.ctermfg, opts.ctermbg, opts.guifg, opts.guibg, opts.target

  if cterm == nil and gui == nil and fg == nil and bg == nil and ctermfg == nil and ctermbg == nil and guifg == nil and guibg == nil and target == nil then
    return nil, "[utils.highlight.set] invalid option"
  end

  local hl_cmd_prev = ""
  local hl_cmd = name
  local hl_ctermfg = ""
  local hl_ctermbg = ""
  local hl_guifg = ""
  local hl_guibg = ""

  if fg ~= nil then
    if type(fg) ~= 'number' and type(fg) ~= 'string' then
      return nil, "[utils.highlight.set] invalid option: fg"
    end
    if type(fg) == 'string' and fg == 'NONE' then
      hl_ctermfg = " ctermfg=" .. fg
      hl_guifg = " guifg=" .. fg
    elseif type(fg) == 'number' and fg >= 0 and fg <= 255 then
      hl_ctermfg = " ctermfg=" .. fg
      hl_guifg = " guifg=" .. M.color_index2rgb(fg)
    else
      return nil, "[utils.highlight.set] invalid option: fg"
    end
  end

  if bg ~= nil then
    if type(bg) ~= 'number' and type(bg) ~= 'string' then
      return nil, "[utils.highlight.set] invalid option: bg"
    end
    if type(bg) == 'string' and bg == 'NONE' then
      hl_ctermbg = " ctermbg=" .. bg
      hl_guibg = " guibg=" .. bg
    elseif type(bg) == 'number' and bg >= 0 and bg <= 255 then
      hl_ctermbg = " ctermbg=" .. bg
      hl_guibg = " guibg=" .. M.color_index2rgb(bg)
    else
      return nil, "[utils.highlight.set] invalid option: bg"
    end
  end

  if ctermfg ~= nil then
    if type(ctermfg) ~= 'number' and type(ctermfg) ~= 'string' then
      return nil, "[utils.highlight.set] invalid option: ctermfg"
    end
    if type(ctermfg) == 'string' and ctermfg ~= 'fg' and ctermfg ~= 'bg' and ctermfg ~= 'NONE' then
      return nil, "[utils.highlight.set] invalid option: ctermfg"
    end
    if type(ctermfg) == 'number' and (ctermfg < 0 or ctermfg > 255) then
      return nil, "[utils.highlight.set] invalid option: ctermfg"
    end
    hl_ctermfg = " ctermfg=" .. ctermfg
  end

  if ctermbg ~= nil then
    if type(ctermbg) ~= 'number' and type(ctermbg) ~= 'string' then
      return nil, "[utils.highlight.set] invalid option: ctermbg"
    end
    if type(ctermbg) == 'string' and ctermbg ~= 'fg' and ctermbg ~= 'bg' and ctermbg ~= 'NONE' then
      return nil, "[utils.highlight.set] invalid option: ctermbg"
    end
    if type(ctermbg) == 'number' and (ctermbg < 0 or ctermbg > 255) then
      return nil, "[utils.highlight.set] invalid option: ctermbg"
    end
    hl_ctermbg = " ctermbg=" .. ctermbg
  end

  if guifg ~= nil then
    if type(guifg) ~= 'string' or (guifg ~= 'fg' and guifg ~= 'bg' and guifg ~= 'NONE' and (not guifg:match('^#%x%x%x%x%x%x$'))) then
      return nil, "[utils.highlight.set] invalid option: guifg"
    end
    hl_guifg = " guifg=" .. guifg
  end

  if guibg ~= nil then
    if type(guibg) ~= 'string' or (guibg ~= 'fg' and guibg ~= 'bg' and guibg ~= 'NONE' and (not guibg:match('^#%x%x%x%x%x%x$'))) then
      return nil, "[utils.highlight.set] invalid option: guibg"
    end
    hl_guibg = " guibg=" .. guibg
  end

  if cterm ~= nil then
    if type(cterm) ~= 'string' then
      return nil, "[utils.highlight.set] invalid option: cterm"
    end
    hl_cmd = hl_cmd .. " cterm=" .. cterm
  end
  hl_cmd = hl_cmd .. hl_ctermfg .. hl_ctermbg

  if gui ~= nil then
    if type(gui) ~= 'string' then
      return nil, "[utils.highlight.set] invalid option: gui"
    end
    hl_cmd = hl_cmd .. " gui=" .. gui
  end
  hl_cmd = hl_cmd .. hl_guifg .. hl_guibg

  if target ~= nil then
    if type(target) ~= 'string' then
      return nil, "[utils.highlight.set] invalid option: target"
    else
      hl_cmd_prev = "clear " .. name
      if target == 'clear' then
        hl_cmd = "link " .. name .. " NONE"
      else
        hl_cmd = "link " .. name .. " " .. target
      end
    end
  end

  if hl_cmd_prev == "" then
    vim.cmd.highlight(hl_cmd)
    return true, "cmd: 'highlight " .. hl_cmd .. "'"
  else
    vim.cmd.highlight(hl_cmd_prev)
    vim.cmd.highlight(hl_cmd)
    return true, "cmd: 'highlight " .. hl_cmd_prev .. "', 'highlight " .. hl_cmd .. "'"
  end
end

function M.on_colorscheme_changed(fn, builtin_only)
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = M.colorscheme_augroup,
    callback = function(ev)
      local name = vim.g.colors_name or (ev.match and ev.match ~= '' and ev.match) or 'shaiya'
      if not builtin_only or name:match('^shaiya') then
        vim.defer_fn(fn, 0)
      end
    end,
  })
  vim.api.nvim_exec_autocmds('ColorScheme', { pattern = vim.g.colors_name })
end

function M.get_synstack()
  -- check treesitter priority
  local ts_synstack = vim.treesitter.get_captures_at_cursor()
  if ts_synstack and not vim.tbl_isempty(ts_synstack) then
    return ts_synstack
  end

  -- check vim syntax highlighting if treesitter was stopped
  if not vim.fn.exists("*synstack") then
    return nil, "feature '*synstack' is not supported"
  end

  local synInfo = {}
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local synStack = vim.fn.synstack(row, col)

  for i, id in ipairs(synStack) do
    local synIDattr = {}
    synIDattr.name = vim.fn.synIDattr(id, "name")
    synIDattr.highlight = vim.api.nvim_get_hl(0, { name = synIDattr.name})

    if vim.tbl_isempty(synIDattr.highlight) then
      synIDattr.highlight = { cleared = true, }
    elseif synIDattr.highlight.link then
      synIDattr.link = synIDattr.highlight.link
      synIDattr.highlight = vim.api.nvim_get_hl(0, { name = synIDattr.name, link = false })
    end

    if synIDattr.highlight.fg ~= nil and type(synIDattr.highlight.fg) == 'number' then
      synIDattr.highlight.guifg = string.format('#%08x', synIDattr.highlight.fg)
      synIDattr.highlight.fg = nil
    end
    if synIDattr.highlight.bg ~= nil and type(synIDattr.highlight.bg) == 'number' then
      synIDattr.highlight.guibg = string.format('#%08x', synIDattr.highlight.bg)
      synIDattr.highlight.bg = nil
    end
    if synIDattr.highlight.sp ~= nil and type(synIDattr.highlight.sp) == 'number' then
      synIDattr.highlight.guisp = string.format('#%08x', synIDattr.highlight.sp)
      synIDattr.highlight.sp = nil
    end

    table.insert(synInfo, synIDattr)
  end

  return synInfo
end

function M.show_synstack()
  local ok, err = M.get_synstack()
  if not ok then
    vim.notify(err, vim.log.levels.ERROR)
  else
    print(vim.inspect(ok))
  end
end

M.setup()

return M
