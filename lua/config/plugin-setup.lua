local M = {}

function M.setup(name)
  M.manager = require("config.plugin-manager-"..name)
  M.manager.setup_plugins()
end

function M.open_plugin_manager()
  M.manager.open()
end

-- Setup lazy.nvim as plugin manager
M.setup("lazy")

return M
