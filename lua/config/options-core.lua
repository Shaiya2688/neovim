local utils = _utils
-- Core options are loaded before plugin setup
-- Add any basic options here

--[[ Default Preferences ]]
vim.g.mapleader = '\\'  -- Set defalut <Leader> for keymap
vim.g.maplocalleader = '\\' -- Set defalut <LocalLeader> for keymap
vim.g.have_nerd_fonts = true  -- Use Nerd Fonts will make Neovim look more stylish, config to 'true' only after you have installed and select the Nerd Fonts for your terminal, or using 'guifont' for your gui Neovim
                              -- The Nerd Font(v3.0 or greater) can download from website: https://www.nerdfonts.com/, you can use the current font name to match the one that suits you best.
vim.g.specially_utilized_window = { -- When opening files, don't use windows containing these filetypes or buftypes
  fts = { "help", "terminal", "Trouble", "qf", "edgy", "neo-tree" },
  bts = { "help", "terminal", "quickfix", },
}
vim.g.specially_hidden_window = {   -- When showing which windows, buffers or files are opened, these filetypes or buftypes are hidden
  fts = { 'neo-tree', 'qf' },
  bts = { 'nofile', 'prompt', 'quickfix' },
}


--[[ Default Options for the Colors & Fonts & Cursor Shapes ]]
if (vim.fn.has('termguicolors') or vim.fn.has('vcon') or vim.fn.has('gui_running')) then
  -- This option may cause screen to flash at Neovim start if terminal is not support 24-bit RGB true color by default
  vim.opt.termguicolors = true -- Force enables 24-bit RGB true color in the TUI if Neovim support terminal true color feature
end
-- TODO: support colorscheme 'shaiya-dark'
-- vim.cmd.colorscheme('shaiya-' .. ((vim.opt.background:get() == 'light' and 'light') or 'dark'))  -- Using the builtin colorscheme
vim.cmd.colorscheme('shaiya-light') -- Current dark colorscheme unsupported
vim.cmd('syntax on')  -- Enable syntax highlighting
if vim.g.have_nerd_fonts then
  vim.opt.ambiwidth = "single"  -- Possible values: 'single', 'double'
  if vim.fn.has('gui_running') then
    -- For gui, you can set guifont option to select the Nerd Fonts
    -- TODO: new default config:
    vim.opt.guifont = "DejaVuSansM_Nerd_Font_Mono:h11" -- Default fonts for me: wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/DejaVuSansMono.zip
  end
end
vim.opt.guicursor = { "n-v-c-i-ci-ve:ver25",
  "sm:block-blinkwait175-blinkoff150-blinkon175",
  "r-cr:hor20",
  "o:hor50",
  "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"
}


--[[ Default Options for the Encoding & Language ]]
vim.opt.encoding = "utf-8" -- String-encoding used internally
-- vim.opt.fileencodings = { "utf-8", "ucs-bom", "shift-jis", "gb18030", "gbk", "gb2312", "cp936" }
if vim.v.lang:lower():match('utf8$') or vim.v.lang:lower():match('utf%-8$') then
  vim.opt.fileencodings = { "utf-8", "ucs-bom", "default", "latin1" }
end
vim.opt.fileformat = "unix" -- Set format of <EOL> for Neovim starts up with an empty buffer
vim.opt.fileformats = { "unix", "dos" } -- Use 'unix' when buffer's fileformat detection failed
vim.opt.helplang = { "cn", "en" }


--[[ Default Options for the View ]]
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Enable relative line numbers
vim.opt.wrap = false -- Disable line wrap
vim.opt.linebreak = true -- Wrap lines at convenient points if wrap option is enabled
vim.opt.breakindent = false -- Don't auto indent for break line if wrap option is enabled
vim.opt.showtabline = 1 -- Enable tab pages line for multiple tab pages
vim.opt.laststatus = 2 -- Always show statusline for last window
vim.opt.showmode = true -- Show current Neovim working mode on the last line
vim.opt.ruler = true -- Enable the ruler at last line for cursor position monitoring
vim.opt.mouse = "nvih" -- Enable mouse support for different modes
vim.opt.cursorline = true -- Enable highlighting of the current cursor line
vim.opt.signcolumn = "auto" -- Show the signcolumn when there is a sign to display, e.g. git status
vim.opt.updatetime = 200 -- Decrease update time for swap file saving and CursorHold event trigger (for the rapid updates of some plugin states)

-- Popup-Menu options
vim.opt.completeopt = "menu,menuone,noselect" -- Show Popup-Menu for Insert mode completion
-- vim.opt.completeopt = { "longest", "menu" }
-- vim.opt.completeopt = { "menu", "noselect" }
vim.opt.pumblend = 10 -- Enables pseudo-transparency for the Popup-Menu blend (0 for fully opaque popupmenu (disabled), 100 for fully transparent background)
vim.opt.pumheight = 10 -- Maximum number of entries in a popup

-- Diff options
vim.opt.diffopt = { "filler", "context:10", "vertical", "foldcolumn:1", "closeoff" }

-- Fold options
vim.opt.foldcolumn = "0" -- Disable draw the foldcolumn
vim.opt.foldlevel = 100
vim.opt.foldmethod = "syntax"
vim.opt.foldenable = true


--[[ Default Options for the Search ]]
vim.opt.hlsearch = true
vim.opt.incsearch = true  -- Show where the pattern while typing a search pattern
vim.opt.ignorecase = true -- Ignoring character case for search patterns
vim.opt.smartcase = false -- Don't overwrite ignore case with capitals


--[[ Default Options for the Editor ]]
-- TODO: not support in nvim
-- vim.opt.clipboard:prepend { "unnamedplus", "autoselect" } -- Copy Visual mode selected to * register for MiddleMouse Paste and sync clipboard register to system clipboard
vim.opt.showmatch = true -- When a bracket is inserted, briefly jump to the matching one if the match can be seen on the screen.
vim.opt.matchpairs = {'(:)', '{:}', '[:]'}
vim.opt.matchtime = 5 -- 0.5 second to show the matching paren
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode

-- File options
vim.opt.autowrite = false -- Disable auto write buffer contents to file
vim.opt.confirm = true    -- Show a dialog to confirm if need save changes before exiting modified buffer
vim.opt.undofile = false  -- Don't reload undo history on the file next loading
vim.opt.undolevels = 1000

-- Indent options
vim.opt.autoindent = false
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.shiftwidth = 0 -- Size of an indent, set to zero to use 'tabstop' value
vim.opt.tabstop = 4 -- Number of spaces tabs count for
vim.opt.expandtab = false -- Use <Tab> instead of <Space> for indent
vim.opt.backspace={ "indent", "eol", "start"}  -- Set backspace allows for autoindent remove or join previous line

-- Command-line completion
vim.opt.wildmenu = true -- Enable command-line completion operates by pressing 'wildchar' (usually <Tab>)
vim.opt.wildmode = { "longest", "list", "full"}  -- Command-line completion mode
vim.opt.wildchar = vim.fn.char2nr("\t") -- Set <Tab> as 'wildchar'

-- Combination Key detection
vim.opt.timeout = true
vim.opt.timeoutlen = 850  -- Decrease wait time to wait for a mapped key sequence to complete
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 50  -- Decrease wait time to wait for a key code sequence to complete


if true then return {} end

vim.opt.inccommand = 'split'  -- Preview substitutions live, as you type!
vim.opt.jumpoptions = "clean"
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

vim.cmd('filetype off')  -- some plugins need to turn this off
