local M = { is_ready = false, }

function M.setup()
  local uv = vim.uv or vim.loop
  local lazypath = vim.fn.stdpath("config") .. "/lua/bundle/lazy/lazy.nvim"

  -- Validate that lazy is available
  if uv.fs_stat(lazypath) then
    vim.opt.rtp:prepend(lazypath)
    if pcall(require, "lazy") then
      M.is_ready = true
      return
    else
      local ok, out = require("config.utils").file.remove_dir(lazypath)
      vim.api.nvim_echo({
        { ("Find invalid lazy from: %s, start re-install\n"):format(lazypath), "WarningMsg" },
        { vim.trim((ok and "") or (out or "")), "WarningMsg" },
      }, true, {})
    end
  end

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
      "--branch=stable",
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

  require("lazy").setup({
    --[[ Import plugins (see the lua/plugins/example.lua for plugin's spec writing guide) ]]
    spec = {
      -- add some excellent plugin repositories and import its plugins
      -- { "M/N", import = "XXX.plugins" },
      -- import/override with your plugins
      { import = "plugins" },
    },

    --[[ Configure any other settings here (see the documentation for more details) ]]
    -- colorscheme that will be used when installing plugins.
    -- install = { colorscheme = { "tokyonight", "habamax" } },
    defaults = {
      -- By default, custom plugins will be loaded during startup.
      -- If you know what you're doing, you can set the lazy-loaded for specified plugin in its plugin spec.
      lazy = false,
      -- It's recommended to leave version=false for now, since a lot the plugin that support versioning have outdated releases, which may break Neovim install.
      version = false, -- always use the latest git commit
      -- version = "*", -- try installing the latest stable version for plugins that support semver
    },
    -- automatically check for plugin updates
    checker = {
      enabled = true, -- check for plugin updates periodically
      notify = false, -- notify on update
    },
    performance = {
      rtp = {
        -- disable some rtp plugins
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          -- "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  })
end

M.setup()

return M
