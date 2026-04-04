-- Post options are loaded after all basic functions have been setup
-- Add any additional options here

if true then return {} end

-- Options for the Plugins
-- vim.opt.grepformat = "%f:%l:%c:%m"
-- vim.opt.grepprg = "rg --vimgrep"
-- vim.opt.autochdir = true
vim.cmd('filetype plugin indent on') -- last option after some plugin has run over, enable Neovim to use different plugins and indentation based on file types, HTML indent use 2 space, Python is 4
