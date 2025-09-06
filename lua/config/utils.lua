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


M.setup()

return M
