local M = {}

function M.setup()
    return
end


--[[ Utils for Mouse ]]
M.mouse = {}

-- Enable mouse support for different modes
function M.mouse.mode_toggle()
  if vim.opt.mouse:get().n then
    vim.opt.mouse = "v"
  else
    vim.opt.mouse = "nvih"
  end
end


--[[ Utils for File operations ]]
M.file = {}

function M.file.remove_dir(path)
  local cmd
  if vim.fn.has('win32') or vim.fn.has('win64') then
    cmd = ('rmdir /s /q %s'):format(vim.fn.shellescape(path))
  else
    cmd = ('rm -rf %s'):format(vim.fn.shellescape(path))
  end
  return pcall(vim.fn.system, cmd)
end


--[[ Utils for Fold ]]
M.fold = {}

function M.fold.column_toggle()
  if vim.opt.foldcolumn:get() == "0" then
    vim.opt.foldcolumn = "auto:3" -- resize to accommodate multiple folds up to the 3 levels
  else
    vim.opt.foldcolumn = "0" -- disable foldcolumn
  end
end


--[[ Utils for Highlight ]]
M.hl = {
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
  default_terminal_ansi_colors = {
    '#000000', '#cd0000', '#00cd00', '#ffaf00', '#5454ff', '#cd00cd',  '#00cdcd', '#d7d7d7',
    '#7f7f7f', '#ff0000', '#00ff00', '#ffff00', '#00afff', '#ff00ff',  '#00ffff', '#ffffff'
  },
}

function M.hl.color_index2rgb(idx)
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
    return M.hl.default_terminal_ansi_colors[idx + 1]
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
--   name:      string
--   {opts}:    table, include additional options:
--   fg:        integer 0-255 (optional), both ctermfg and guifg will be affect
--   bg:        integer 0-255 (optional), both ctermbg and guibg will be affect
--   cterm:     string (optional)
--   ctermfg:   integer 0-255 (optional)
--   ctermbg:   integer 0-255 (optional)
--   gui:       string (optional)
--   guifg:     string #RRGGBB (optional)
--   guibg:     string #RRGGBB (optional)
-- And at least one option must be included
function M.hl.create_group(name, opts)
  if name == nil or type(name) ~= 'string' then
    return nil, "[utils.hl.set] invalid name"
  end

  if opts == nil or type(opts) ~= 'table' then
    return nil, "[utils.hl.set] invalid option"
  end

  local cterm, gui, fg, bg, ctermfg, ctermbg, guifg, guibg = opts.cterm, opts.gui, opts.fg, opts.bg, opts.ctermfg, opts.ctermbg, opts.guifg, opts.guibg

  if cterm == nil and gui == nil and fg == nil and bg == nil and ctermfg == nil and ctermbg == nil and guifg == nil and guibg == nil then
    return nil, "[utils.hl.set] invalid option"
  end

  local hl_cmd = name
  local hl_ctermfg = ""
  local hl_ctermbg = ""
  local hl_guifg = ""
  local hl_guibg = ""

  if fg ~= nil then
    if type(fg) ~= 'number' or fg < 0 or fg > 255 then
      return nil, "[utils.hl.set] invalid option: fg"
    end
    hl_ctermfg = " ctermfg=" .. fg
    hl_guifg = " guifg=" .. M.hl.color_index2rgb(fg)
  end

  if bg ~= nil then
    if type(bg) ~= 'number' or bg < 0 or bg > 255 then
      return nil, "[utils.hl.set] invalid option: bg"
    end
    hl_ctermbg = " ctermbg=" .. bg
    hl_guibg = " guibg=" .. M.hl.color_index2rgb(bg)
  end

 if ctermfg ~= nil then
    if type(ctermfg) ~= 'number' or ctermfg < 0 or ctermfg > 255 then
      return nil, "[utils.hl.set] invalid option: ctermfg"
    end
    hl_ctermfg = " ctermfg=" .. ctermfg
  end

  if ctermbg ~= nil then
    if type(ctermbg) ~= 'number' or ctermbg < 0 or ctermbg > 255 then
      return nil, "[utils.hl.set] invalid option: ctermbg"
    end
    hl_ctermbg = " ctermbg=" .. ctermbg
  end

  if guifg ~= nil then
    if type(guifg) ~= 'string' or (not guifg:match('^#%x%x%x%x%x%x$')) then
      return nil, "[utils.hl.set] invalid option: guifg"
    end
    hl_guifg = " guifg=" .. guifg
  end

  if guibg ~= nil then
    if type(guibg) ~= 'string' or (not guibg:match('^#%x%x%x%x%x%x$')) then
      return nil, "[utils.hl.set] invalid option: guibg"
    end
    hl_guibg = " guibg=" .. guibg
  end

  if cterm ~= nil then
    if type(cterm) ~= 'string' then
      return nil, "[utils.hl.set] invalid option: cterm"
    end
    hl_cmd = hl_cmd .. " cterm=" .. cterm
  end
  hl_cmd = hl_cmd .. hl_ctermfg .. hl_ctermbg

  if gui ~= nil then
    if type(gui) ~= 'string' then
      return nil, "[utils.hl.set] invalid option: gui"
    end
    hl_cmd = hl_cmd .. " gui=" .. gui
  end
  hl_cmd = hl_cmd .. hl_guifg .. hl_guibg

  vim.cmd.highlight(hl_cmd)

  return true
end


M.setup()

return M
