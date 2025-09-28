return {

  {

    -- Enhance and style the statusline and tabline
    "nvim-lualine/lualine.nvim",
    -- See `:h lualine` for more help information
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_fonts },  -- optional for getting pretty icons, but requires a Nerd Font.
    },
    opts = function()
      local builtin_theme = function()
        local colors = {
          darkgray  = '#303030',
          gray      = '#D0D0D0',
          black     = '#202020',
          white     = '#E0E0E0',
          green     = '#00C918',
          brown     = '#FD8900',
          -- darkbrown = "#cc6633",
          purple    = '#AD00A1',
          blue      = '#3777E6',
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
      local theme_name = builtin_theme -- All available themes are listed in lualine's THEMES.md, e.g. 'gruvbox', 'powerline' .etc
      local opts = {
        options = {
          theme = theme_name, -- lualine theme
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
          section_separators = vim.g.have_nerd_fonts and { left = '', right = '' } or { left = ' ', right = ' '},
          component_separators = { left = '', right = '' },
          always_divide_middle = true, -- Left sections i.e. 'a','b' and 'c' can't take over the entire statusline even if neither of 'x', 'y' or 'z' are present
        },
        sections = {
          -- `buffers` (shows currently available buffers)
          -- `tabs` (shows currently available tabs)
          -- `windows` (shows currently available windows)
          -- `lsp_status` (shows active LSPs in the current buffer and a progress spinner)
          lualine_a = {'mode'},
          lualine_b = {
            {
              'branch',
              icon = { '', align = 'left', },
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
              color = theme_name == 'auto' and { fg='#ffa500', gui="nocombine,bold" } or { gui="nocombine,bold" },
              on_click = function(num, key)
                if key ==  'l' then
                  local fname = num == 1 and vim.fn.expand('%:p:~') or vim.fn.expand('%:p')
                  if fname ~= '' then
                    vim.notify(fname, vim.log.levels.INFO)
                    -- TODO: sync to system clipbords
                  end
                end
              end,
            },
            {
              function()
                local fname = vim.fn.expand('%:p')
                local ftime = vim.fn.filereadable(fname) == 0 and '' or os.date('%Y/%m/%d %H:%M:%S', vim.fn.getftime(fname))
                return ftime
              end,
              color = theme_name == 'auto' and { fg='#ffa500', gui="nocombine,bold" } or { gui="nocombine,bold" },
            },
          },
          lualine_x = {
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
              -- 󰅚 󰀪 󰋽 󰌶
              --    󰌵
              symbols = vim.g.have_nerd_fonts and {
              } or {
                error = 'E',
                warn = 'W',
                info = 'I',
                hint = 'H',
              },
              colored = true,           -- Displays diagnostics status in color
              update_in_insert = false, -- Update diagnostics in insert mode.
              always_visible = true,   -- Show diagnostics even if there are none.
            },
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
              color = theme_name == 'auto' and { fg='#ffa500', gui="nocombine,bold" } or { gui="nocombine,bold" },
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
              color = theme_name == 'auto' and { fg='#ffa500', gui="nocombine,bold" } or { gui="nocombine,bold" },
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
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        -- extensions = { "neo-tree", "lazy", "fzf" },
        extensions = {},
      }
      return opts
    end
  },

}
