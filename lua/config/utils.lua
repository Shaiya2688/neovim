local M = {}

function M.setup()
    return
end

M.mouse = {}
-- Enable mouse support for different modes
function M.mouse.mode_toggle()
  if vim.opt.mouse:get().n then
    vim.opt.mouse = "v"
  else
    vim.opt.mouse = "nvih"
  end
end

M.setup()

return M
