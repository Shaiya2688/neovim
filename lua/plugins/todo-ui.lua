return {

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_fonts },  -- optional for getting pretty icons, but requires a Nerd Font.
    },

    opts = function()
      local theme_name = 'auto'
      local opts = {
        options = {
          icons_enabled = vim.g.have_nerd_fonts,
          component_separators = { left = '', right = ''},
          -- component_separators = { left = '', right = ''},
          section_separators = vim.g.have_nerd_fonts and { left = '', right = '' } or { left = '', right = ''},
          -- section_separators = vim.g.have_nerd_fonts and { left = '', right = '' } or {},
          globalstatus = vim.o.laststatus == 3, -- enable global statusline (have a single statusline
                                                -- at bottom of neovim instead of one for  every window).
                                                -- This feature is only available in neovim 0.7 and higher.
          disabled_filetypes = {   -- Filetypes to disable lualine for.
            statusline = {},       -- only ignores the ft for statusline.
            -- statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
            winbar = {},           -- only ignores the ft for winbar.
          },
          ignore_focus = {},     -- If current filetype is in this list it'll
                                 -- always be drawn as inactive statusline
                                 -- and the last window will be drawn as active statusline.
                                 -- for example if you don't want statusline of
                                 -- your file tree / sidebar window to have active
                                 -- statusline you can add their filetypes here.
                                 --
                                 -- Can also be set to a function that takes the
                                 -- currently focused window as its only argument
                                 -- and returns a boolean representing whether the
                                 -- window's statusline should be drawn as inactive.

          always_divide_middle = true, -- When set to true, left sections i.e. 'a','b' and 'c'
                                       -- can't take over the entire statusline even
                                       -- if neither of 'x', 'y' or 'z' are present.
          always_show_tabline = true, -- When set to true, if you have configured lualine for displaying tabline
                                      -- then tabline will always show. If set to false, then tabline will be displayed
                                      -- only when there are more than 1 tab. (see :h showtabline)
          theme = theme_name,         -- lualine theme
          refresh = {                 -- sets how often lualine should refresh it's contents (in ms)
            statusline = 100,        -- The refresh option sets minimum time that lualine tries
            tabline = 1000,           -- to maintain between refresh. It's not guarantied if situation
            winbar = 1000,            -- arises that lualine needs to refresh itself before this time
                                      -- it'll do it.
           refresh_time = 16,         -- ~60fps the time after which refresh queue is processed. Mininum refreshtime for lualine
           events = {                -- The auto command events at which lualine refreshes
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
          }
        },
        sections = {

          -- - `buffers` (shows currently available buffers)
          -- - `diagnostics` (diagnostics count from your preferred source)
          -- - `filesize`
          -- - `hostname`
          -- - `selectioncount` (number of selected characters or lines)
          -- - `tabs` (shows currently available tabs)
          -- - `windows` (shows currently available windows)
          -- - `lsp_status` (shows active LSPs in the current buffer and a progress spinner)

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
                added    = { fg = '#008000', gui='nocombine'},
                modified = { fg = '#ffa500', gui='nocombine'},
                removed  = { fg = '#ff0000', gui='nocombine' },
              } or {},
              symbols = {added = '+', modified = '~', removed = '-'},
            },
            -- TODO: TBD
            'diagnostics',
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
              color = theme_name == 'auto' and { fg='#ffa500', gui="nocombine,bold"} or {},
            },
            {
              function()
                local fname = vim.fn.expand('%:p')
                local ftime = vim.fn.filereadable(fname) == 0 and '' or os.date('%Y/%m/%d %H:%M:%S', vim.fn.getftime(fname))
                return ftime
              end,
              color = theme_name == 'auto' and { fg='#ffa500', gui="nocombine,bold"} or {},
            },
          },
          lualine_x = {
            {
              'filetype',
              color = theme_name == 'auto' and { fg='#ffa500', gui="nocombine,bold"} or {},
              icon_only = false,
              icon = { align = 'right' },
              colored = true, -- Displays filetype icon in color itself
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
                unix = '[unix]',
                dos = '[dos]',
                mac = '[mac]',
              } or {
                unix = '[unix]',
                dos = '[dos]',
                mac = '[mac]',
              },
              padding = { left = 0, right = 1 },
            },

          },
          lualine_y = {
            {
              'searchcount',
              separator = { left = '', right = '' },
              padding = { left = 1, right = 1 },
            },
            {
              'progress',
              separator = { left = '', right = '' },
              padding = { left = 1, right = 0 },
            },
            function()
              local row, col = unpack(vim.api.nvim_win_get_cursor(0))
              local lines = vim.api.nvim_buf_line_count(0)
              return "☰".. row .. "/" .. lines .. " : " .. col .. ' '
            end,
          },
          lualine_z = {
            vim.o.laststatus == 3 and {
              function()
                return os.date("%T")
              end,
              separator = { left = '', right = ''}
            } or {},
          }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
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
              color = theme_name == 'auto' and { fg='#806000', gui="nocombine,bold"} or {},
            },
          },
          lualine_x = {},
          lualine_y = {
            {
              function()
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                local lines = vim.api.nvim_buf_line_count(0)
                return "☰".. row .. "/" .. lines .. " : " .. col .. ' '
              end,
              separator = { left = '', right = ''}
            },
          },
          lualine_z = {}
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
