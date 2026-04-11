local utils = _utils

local lualine_builtin_theme = function()
  local colors = {
    darkgray  = '#303030',
    gray      = '#D0D0D0',
    black     = '#202020',
    white     = '#E0E0E0',
    green     = '#80c918', -- '#00C918'
    brown     = '#FD8900',
    purple    = '#CD00DD', --'#AD00A1'
    blue      = '#3797E6', -- '#3777E7'
    pink      = '#FF0086', -- Magenta
  }
  return {
    normal = {
      a = { fg = colors.black, bg = colors.green, gui = 'bold' },
      b = { fg = colors.white, bg = colors.darkgray },
      c = { fg = colors.brown, bg = colors.black },
    },
    visual = {
      a = { fg = colors.black, bg = colors.purple, gui = 'bold' },
      b = { fg = colors.white, bg = colors.darkgray },
      c = { fg = colors.brown, bg = colors.black },
    },
    insert = {
      a = { fg = colors.black, bg = colors.blue, gui = 'bold' },
      b = { fg = colors.white, bg = colors.darkgray },
      c = { fg = colors.brown, bg = colors.black },
    },
    replace = {
      a = { fg = colors.black, bg = colors.pink, gui = 'bold' },
      b = { fg = colors.white, bg = colors.darkgray },
      c = { fg = colors.brown, bg = colors.black },
    },
    inactive = {
      a = { fg = colors.gray, bg = colors.black, gui = 'bold' },
      b = { fg = colors.gray, bg = colors.black },
      c = { fg = colors.gray, bg = colors.black },
    },
    command = {
      a = { fg = colors.black, bg = colors.green, gui = 'bold' },
      b = { fg = colors.white, bg = colors.darkgray },
      c = { fg = colors.brown, bg = colors.black },
    },
    terminal = {
      a = { fg = colors.black, bg = colors.green, gui = 'bold' },
      b = { fg = colors.white, bg = colors.darkgray },
      c = { fg = colors.brown, bg = colors.black },
    },
  }
end

local lualine_on_click_file = function(num, key)
  if key ==  'l' then
    local fname = num == 1 and vim.fn.expand('%:p:~') or vim.fn.expand('%:p')
    if fname ~= '' then
      vim.notify(fname, vim.log.levels.INFO)
      -- TODO: sync to system clipbords
    end
  end
end

-- table to map mode to highlight suffixes
local lualine_mode_to_highlight = {
  ['VISUAL'] = '_visual',
  ['V-BLOCK'] = '_visual',
  ['V-LINE'] = '_visual',
  ['SELECT'] = '_visual',
  ['S-LINE'] = '_visual',
  ['S-BLOCK'] = '_visual',
  ['REPLACE'] = '_replace',
  ['V-REPLACE'] = '_replace',
  ['INSERT'] = '_insert',
  ['COMMAND'] = '_command',
  ['EX'] = '_command',
  ['MORE'] = '_command',
  ['CONFIRM'] = '_command',
  ['TERMINAL'] = '_terminal',
}

local aerial_status = function(opts)
  opts = vim.tbl_extend('force', {
    colored = true,
    sep = '->',
    depth = 5,
    section = 'c',
  }, opts or {})

  return function()
    local mode = require('lualine.utils.mode').get_mode()
    local is_focused = require('lualine.utils.utils').is_focused()
    local _suffix
    if is_focused == false then
      _suffix = '_inactive'
    else
      _suffix = lualine_mode_to_highlight[mode] or '_normal'
    end
    local base_section = opts.section
    if base_section >= 'x' then
      base_section = string.char(string.byte('c') - (string.byte(base_section) - string.byte('x')))
    end
    local base_hl_group = ('lualine_%s%s'):format(base_section, _suffix)
    local base_hl_attr = vim.api.nvim_get_hl(0, { name = base_hl_group, link = false })
    local function draw_text(hl, text)
      return string.format('%%#%s#%s%%*', hl, text)
    end

    local ok, aerial = pcall(require, 'aerial')
    if ok then
      local symbols = aerial.get_location(true) or {}
      if not vim.tbl_isempty(symbols) then
        local pieces = {}
        local depth = opts.depth > #symbols and #symbols or opts.depth
        while #symbols > depth do
          table.remove(symbols, 1)
        end
        for i, sym in ipairs(symbols) do
          local icon = sym.icon or ''
          local name = sym.name or ''
          local kind = sym.kind or 'Undefined'
          if opts.colored then
            local hl_group = ('lualine_%s_aerial_%s%s'):format(opts.section, kind, _suffix)
            if vim.fn.hlexists(hl_group) == 0 then
              local target = 'Aerial' .. kind .. 'Icon'
              local target_hl_attr
              if vim.fn.hlexists(target) == 1 then
                target_hl_attr = vim.api.nvim_get_hl(0, { name = target, link = false, })
              elseif vim.fn.hlexists(base_hl_group) == 1 then
                target_hl_attr = base_hl_attr
              else
                target_hl_attr = vim.api.nvim_get_hl(0, { name = 'StatusLine', link = false })
              end
              vim.api.nvim_set_hl(0, hl_group, { bg = base_hl_attr.bg, fg = target_hl_attr.fg, bold = true, nocombine = true, })
            end
            table.insert(pieces, draw_text(hl_group, string.format('%s%s', icon, name)))
            if i < depth then
              table.insert(pieces, draw_text(base_hl_group, string.format(' %s ', opts.sep)))
            end
          else
            table.insert(pieces, string.format('%s%s', icon, name))
            if i < depth then
              table.insert(pieces, string.format(' %s ', opts.sep))
            end
          end
        end
        return table.concat(pieces, '')
      end
    end
    return ''
  end
end

-- Used to override default color for aerial component
local aerial_color = function(section)
  local mode = require('lualine.utils.mode').get_mode()
  local is_focused = require('lualine.utils.utils').is_focused()
  local _suffix
  if is_focused == false then
    _suffix = '_inactive'
  else
    _suffix = lualine_mode_to_highlight[mode] or '_normal'
  end
  local ok, aerial = pcall(require, 'aerial')
  if ok then
    local symbols = aerial.get_location(true) or {}
    for i, sym in ipairs(symbols) do
      local hl_group = ('lualine_%s_aerial_LLAerial%s%s'):format(section or 'c', sym.kind, _suffix)
      local target= ('lualine_%s_aerial_LLAerial%sIcon%s'):format(section or 'c', sym.kind, _suffix)
      if vim.fn.hlexists(target) == 1 and vim.fn.hlexists(hl_group) == 1 then
        local attr = vim.api.nvim_get_hl(0, { name = hl_group })
        local new_attr = vim.api.nvim_get_hl(0, { name = target })
        if not attr.bold then
          new_attr.bold = true
          vim.api.nvim_set_hl(0, hl_group, new_attr)
        end
      end
    end
  end
  return { fg='#fd8900', gui="nocombine,bold" } -- Provide default color if 'aerial' requires it in the future
end

return {

  {
    -- Enhance and style the statusline and tabline
    "nvim-lualine/lualine.nvim",
    -- See `:h lualine` for more help information
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_fonts },  -- optional for getting pretty icons, but requires a Nerd Font.
    },
    init = function()
      vim.o.laststatus = 3  -- Force lualine using global statusline if lualine enabled
    end,
    opts = function()
      local theme_name = lualine_builtin_theme -- All available themes are listed in lualine's THEMES.md, e.g. 'gruvbox', 'powerline' .etc
      local opts = {
        options = {
          theme = theme_name,
          icons_enabled = vim.g.have_nerd_fonts,
          globalstatus = vim.o.laststatus == 3, -- enable global statusline (have a single statusline at bottom of neovim instead of one for every window).
          always_show_tabline = true, -- If you have configured lualine for displaying tabline then tabline will always show
          disabled_filetypes = { -- Filetypes to disable lualine for
            statusline = {},
            winbar = {},
          },
          ignore_focus = {}, -- Filetypes to be drawn as inactive statusline always
          refresh = { -- sets how often lualine should refresh it's contents (in ms)
            statusline = 100,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16, -- ~60fps the time after which refresh queue is processed. Mininum refreshtime for lualine
            events = {         -- The auto command events at which lualine refreshes
              'WinEnter',
              'BufEnter',
              'BufWritePost',
              'SessionLoadPost',
              'FileChangedShellPost',
              'VimResized',
              'Filetype',
              'CursorMoved',
              'CursorMovedI',
              'ModeChanged',
            },
          },
          -- +-------------------------------------------------+
          -- | A | B | C                             X | Y | Z |
          -- +-------------------------------------------------+
          section_separators = vim.g.have_nerd_fonts and { left = '', right = ' ' } or { left = ' ', right = ' '},
          component_separators = { left = '', right = '' },
          always_divide_middle = true, -- Left sections i.e. 'a','b' and 'c' can't take over the entire statusline even if neither of 'x', 'y' or 'z' are present
        },
        sections = { -- Enable statusline
          lualine_a = {'mode'},
          lualine_b = {
            {
              'branch',
              icon = { vim.g.have_nerd_fonts and '' or '⎇', align = 'left', },
              icons_enabled = true,
              separator = '',
            },
            {
              'diff',
              colored = true, -- Displays a colored diff status
              diff_color = (vim.g.colors_name == 'shaiya-light' or vim.g.colors_name == 'shaiya-dark') and {
                added    = { fg = '#008000', gui='nocombine,bold'},
                modified = { fg = '#ffa500', gui='nocombine,bold'},
                removed  = { fg = '#ff0000', gui='nocombine,bold' },
              } or {},
              symbols = {added = '+', modified = '~', removed = '-'},
            },
          },
          lualine_c = {
            {
              'filename',
              file_status = true,      -- Displays file status (readonly status, modified status)
              newfile_status = false,  -- Display new file status (new file means no write after created)
              path = 0,                -- 0: Just the filename, 1: Relative path, 2: Absolute path, 3: Absolute path, with tilde as the home directory, 4: Filename and parent dir, with tilde as the home directory
              shorting_target = 40,    -- Shortens path to leave 40 spaces in the window for other components
              symbols = {
                modified = '[+]',      -- Text to show when the file is modified.
                readonly = '',        -- Text to show when the file is non-modifiable or readonly.
                unnamed = '[No Name]', -- Text to show for unnamed buffers.
                newfile = '[New]',     -- Text to show for newly created file before first write
              },
              separator = ' ',
              color = theme_name == 'auto' and { fg='#fd8900', gui="nocombine,bold" } or { gui="nocombine,bold" },
              on_click = lualine_on_click_file,
            },
            {
              function()
                local fname = vim.fn.expand('%:p')
                local ftime = vim.fn.filereadable(fname) == 0 and '' or os.date('%Y/%m/%d %H:%M:%S', vim.fn.getftime(fname))
                return ftime
              end,
              color = theme_name == 'auto' and { fg='#fd8900', gui="nocombine,bold" } or { gui="nocombine,bold" },
              on_click = lualine_on_click_file,
            },
          },
          lualine_x = {
            -- {
            --   'aerial',
            --   sep = ' » ', -- The separator to be used to separate symbols in status line
            --   sep_prefix = false, -- Prefix the separator before the first symbol
            --   sep_highlight = 'lualine_c_normal', -- The separator highlight group
            --   sep_icon = '', -- The separator between the icon and the symbol name (when icons are enabled)
            --   depth = 5, -- The number of symbols to render top-down. In order to render only 'N' last symbols, 'depth = -1' can be used in order to render only current symbol
            --   dense = false, -- When 'dense' mode is on, only a single icon that represents the kind of current symbol is rendered at the beginning of status line
            --   dense_sep = '.', -- The separator to be used to separate symbols in dense mode.
            --   colored = true, -- Color the symbol icons.
            --   color = function(section)
            --     pcall(aerial_color, section.section) -- Override default color for aerial component
            --   end,
            --   separator = ' ',
            -- },
            {
              aerial_status({ section = 'x', sep = '»', depth = 3, colored = true, }), -- The original 'aerial' status cannot be applied to the lualine theme
              color = theme_name == 'auto' and { fg='#fd8900', gui="nocombine,bold" } or { gui="nocombine,bold" },
              separator = ' ',
            },
            {
              -- TODO: TBD
              'diagnostics',
              -- Table of diagnostic sources, available sources are: 'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
              -- or a function that returns a table as such: { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
              -- sources = { 'nvim_diagnostic', 'coc' },
              sections = { 'error', 'warn', 'info', 'hint' }, -- Displays diagnostics for the defined severity types
              diagnostics_color = {
                --   error = 'DiagnosticError',
                --   warn  = 'DiagnosticWarn',
                --   info  = 'DiagnosticInfo',
                --   hint  = 'DiagnosticHint',
              },
              symbols = vim.g.have_nerd_fonts and {
                error = '',  -- 󰅚
                warn  = '',  -- 󰀪
                info  = '',  -- 󰋽
                hint  = '󰌶',  -- 󰌵,
              } or {
                error = 'E:',
                warn = 'W:',
                info = 'I:',
                hint = 'H:',
              },
              colored = true,           -- Displays diagnostics status in color
              update_in_insert = false, -- Update diagnostics in insert mode.
              always_visible = true,   -- Show diagnostics even if there are none.
            },
            -- function()
            --   local name = ""
            --   local ok, as = pcall(require, 'auto-session.lib')
            --   if ok then
            --     name = as.current_session_name(true)
            --   end
            --   if name ~= "" then
            --     local icon = vim.g.have_nerd_fonts and ' ' or ""
            --     name = icon .. name
            --   end
            --   return name
            -- end,
            {
              -- TODO: TBD
              'lsp_status',
              icon = '',
              symbols = {
                spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }, -- Standard unicode symbols to cycle through for LSP progress
                done = '✓', -- Standard unicode symbol for when LSP is done:
                separator = ' ', -- Delimiter inserted between LSP names:
              },
              ignore_lsp = {}, -- List of LSP names to ignore (e.g., `null-ls`):
            },
          },
          lualine_y = {
            {
              'filetype',
              color = theme_name == 'auto' and { fg='#fd8900', gui="nocombine,bold" } or { gui="nocombine,bold" },
              icon_only = false,
              icon = { align = 'right' },
              colored = true, -- Displays filetype icon in color
            },
            {
              'encoding',
              show_bomb = false, -- Show '[BOM]' when the file has a byte-order mark
              separator = '',
            },
            {
              'fileformat',
              icons_enabled = true,
              symbols = vim.g.have_nerd_fonts and {
                unix = '[unix] ',
                dos = '[dos] ',
                mac = '[mac] ',
              } or {
                unix = '[unix]',
                dos = '[dos]',
                mac = '[mac]',
              },
              padding = { left = 0, right = 1 },
            },
          },
          lualine_z = {
            {
              'searchcount',
              icon = { '', align = 'left', },
              maxcount = 9999,
              separator = { left = '', right = '' },
              padding = 1,
            },
            {
              'progress',
              separator = { left = '', right = '' },
              padding = { left = 1, right = 0 },
            },
            function()
              local row, col = unpack(vim.api.nvim_win_get_cursor(0))
              local lines = vim.api.nvim_buf_line_count(0)
              return "☰ ".. row .. "/" .. lines .. " : " .. col
            end,
            {
              function()
                return vim.o.laststatus == 3 and os.date("%T") or ''
              end,
              separator = { left = '', right = ''},
            }
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              'filename',
              file_status = true,      -- Displays file status (readonly status, modified status)
              newfile_status = false,  -- Display new file status (new file means no write after created)
              path = 3,                -- 0: Just the filename, 1: Relative path, 2: Absolute path, 3: Absolute path, with tilde as the home directory, 4: Filename and parent dir, with tilde as the home directory
              shorting_target = 40,    -- Shortens path to leave 40 spaces in the window for other components
              symbols = {
                modified = '[+]',      -- Text to show when the file is modified.
                readonly = '',        -- Text to show when the file is non-modifiable or readonly.
                unnamed = '[No Name]', -- Text to show for unnamed buffers.
                newfile = '[New]',     -- Text to show for newly created file before first write
              },
              separator = ' ',
              color = theme_name == 'auto' and { fg='#fd8900', gui="nocombine,bold" } or { gui="nocombine,bold" },
            },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            {
              'progress',
              separator = { left = '', right = '' },
              padding = { left = 1, right = 0 },
            },
            {
              function()
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                local lines = vim.api.nvim_buf_line_count(0)
                return "☰ ".. row .. "/" .. lines .. " : " .. col
              end,
              separator = { left = '', right = ''}
            },
          },
        },
        tabline = vim.g.tabline ~= 'lualine' and {} or { -- Enable tabline for tabs + wins
          lualine_a = {
            {
              function()
                return "tabs"
              end,
              separator = { left = '', right = vim.g.have_nerd_fonts and '' or '' },
              color = { fg='#D0D0D0', bg='#404040', gui="nocombine,bold" }
            },
            {
              'tabs',
              tab_max_length = 40,  -- Maximum width of each tab. The content will be shorten dynamically (example: apple/orange -> a/orange)
              max_length = function() -- Maximum width of tabs component, it can also be a function that returns the value of `max_length` dynamically.
                if vim.g.tabline_show == 0 then
                  return vim.o.columns * 17 / 30 -- for window actived
                else
                  return vim.o.columns * 7 / 30  -- for buffer actived
                end
              end,
              mode = 2, -- 0: Shows tab_nr, 1: Shows tab_name, 2: Shows tab_nr + tab_name
              path = 0, -- 0: just shows the filename, 1: shows the relative path and shorten $HOME to ~, 2: shows the full path, 3: shows the full path and shorten $HOME to ~
              section_separators = { left = '', right = '' },
              component_separators = { left = '', right = '' },
              use_mode_colors = true, -- Automatically updates active window color to match color of other components (will be overidden if tabs_color is set)
              tabs_color = {
                -- active = 'lualine_a_normal',     -- Color for active tab.
                -- inactive = 'lualine_a_inactive', -- Color for inactive tab.
              },
              show_modified_status = true,  -- Shows a symbol next to the tab name if the file has been modified.
              symbols = {
                modified = '[+]',  -- Text to show when the file is modified.
              },
              -- fmt = function(name, context) -- Format tab_name
              --   local buflist = vim.fn.tabpagebuflist(context.tabnr)
              --   local winnr = vim.fn.tabpagewinnr(context.tabnr)
              --   local bufnr = buflist[winnr]
              --   local mod = vim.fn.getbufvar(bufnr, '&mod')
              --   return name .. (mod == 1 and ' +' or '')
              -- end
            },
          },
          lualine_z = {
            {
              function()
                return vim.g.tabline_show == 0 and "wins" or "bufs"
              end,
              separator = { left = '', right = vim.g.have_nerd_fonts and '' or '' },
              color = { fg='#D0D0D0', bg='#404040', gui="nocombine,bold" }
            },
            {
              'windows',
              section_separators = { left = '', right = '' },
              component_separators = { left = '', right = '' },
              show_filename_only = true,   -- Shows shortened relative path when set to false.
              show_modified_status = true, -- Shows indicator when the window is modified.
              symbols = {
                modified = '[+]',  -- Text to show when the file is modified.
              },
              mode = 2, -- 0: Shows window name, 1: Shows window index, 2: Shows window name + window index
              max_length = vim.o.columns * 1 / 3, -- Maximum width of windows component, it can also be a function that returns the value of `max_length` dynamically.
              filetype_names = { -- Shows specific window name for specific filetypes
                TelescopePrompt = 'Telescope',
                dashboard = 'Dashboard',
                packer = 'Packer',
                fzf = 'FZF',
                alpha = 'Alpha'
              },
              disabled_buftypes = vim.g.specially_hidden_window.bts or {}, -- Hide a window if its buffer's type is disabled
              use_mode_colors = true, -- Automatically updates active window color to match color of other components (will be overidden if windows_color is set)
              windows_color = {
                -- active = 'lualine_z_normal',     -- Color for active window.
                -- inactive = 'lualine_z_inactive', -- Color for inactive window.
              },
              cond = function() return vim.g.tabline_show == 0 end,
            },
            {
              'buffers',
              section_separators = { left = '', right = '' },
              component_separators = { left = '', right = '' },
              show_filename_only = true,        -- Shows shortened relative path when set to false.
              hide_filename_extension = false,  -- Hide filename extension when set to true.
              show_modified_status = true,      -- Shows indicator when the buffer is modified.
              mode = 4, -- 0: Shows buffer name, 1: Shows buffer index, 2: Shows buffer name + buffer index, 3: Shows buffer number, 4: Shows buffer name + buffer number
              max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component, it can also be a function that returns the value of `max_length` dynamically.
              filetype_names = { -- Shows specific buffer name for specific filetypes
                TelescopePrompt = 'Telescope',
                dashboard = 'Dashboard',
                packer = 'Packer',
                fzf = 'FZF',
                alpha = 'Alpha'
              },
              use_mode_colors = true, -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
              buffers_color = {
                -- active = 'lualine_z_normal',     -- Color for active buffer.
                -- inactive = 'lualine_z_inactive', -- Color for inactive buffer.
              },
              symbols = {
                modified = '[+]',     -- Text to show when the buffer is modified
                alternate_file = '#', -- Text to show to identify the alternate file
                directory =  vim.g.have_nerd_fonts and '' or '[D]', -- Text to show when the buffer is a directory
              },
              cond = function() return vim.g.tabline_show == 1 end,
            },
          },
        },
        winbar = {}, inactive_winbar = {}, -- Disable winbar for active and inactive windows
        extensions = {}, -- Disable lualine extensions, which are used to change statusline appearance for specified filetypes, e.g. { "neo-tree", "lazy", "fzf", "quickfix" }
      }
      return opts
    end,
    config = function(_, opts)
      local ok, lualine = pcall(require, 'lualine')
      if not ok then return end
      lualine.setup(opts)
      if vim.g.tabline ~= 'lualine' then return end
      vim.keymap.set('n', '<Leader>tr', function()
        if not vim.fn.exists('*LualineRenameTab') then return end
        local name = utils.ui.input("> New tabname: ")
        if name then
          vim.fn.execute('LualineRenameTab ' .. name)
        end
      end, { desc = "Rename or Reset The Tab Name" })
    end
  },

}
