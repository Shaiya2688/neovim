local M = { is_ready = false, }

function M.setup()
  local uv = vim.uv or vim.loop
  local lazypath = vim.fn.stdpath("config") .. "/lua/bundle/lazy/lazy.nvim"

  -- Bootstrap lazy.nvim
  if not uv.fs_stat(lazypath) then
    vim.api.nvim_echo({
      {
        "Cloning lazy.nvim\n\n",
        "DiagnosticInfo",
      },
    }, true, {})
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local ok, out = pcall(vim.fn.system, {
      "git",
      "clone",
      "--filter=blob:none",
      lazyrepo,
      lazypath,
    })
    if not ok or vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim\n", "ErrorMsg" },
        { vim.trim(out or ""), "WarningMsg" },
        { "\nPress any key to continue...", "MoreMsg" },
      }, true, {})
      -- vim.fn.getchar()
      return
    end
  end
  vim.opt.rtp:prepend(lazypath)

  -- Validate that lazy is available
  if not pcall(require, "lazy") then
    vim.api.nvim_echo({
      { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" },
      { "Press any key to continue...", "MoreMsg" },
    }, true, {})
    -- vim.fn.getchar()
  else
    M.is_ready = true
  end
end

function M.setup_plugins()
  if not M.is_ready then
    return
  end

  require("lazy").setup({})
end

M.setup()

return M
