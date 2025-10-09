--[[ Utils for Mouse ]]
local M = {}

function M.setup()
end

-- Enable mouse support for different modes
function M.mode_toggle()
  if vim.opt.mouse:get().n then
    vim.opt.mouse = "v"
  else
    vim.opt.mouse = "nvih"
  end
end

M.setup()

return M
