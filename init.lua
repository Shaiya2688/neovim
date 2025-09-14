-- loading some useful features based on the vim script
vim.cmd.source(vim.fn.stdpath('config') .. '/init.vimrc.vim')

-- loading configs based on the lua script
require("config")
