--[[ Utils for Fold ]]
local M = {}

function M.setup()
end

function M.column_toggle()
  if vim.opt.foldcolumn:get() == "0" then
    vim.opt.foldcolumn = "auto:9" -- resize to accommodate multiple folds up to the 9 levels
  else
    vim.opt.foldcolumn = "0" -- disable foldcolumn
  end
end

M.setup()

return M
