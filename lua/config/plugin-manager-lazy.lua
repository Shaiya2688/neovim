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
    spec = {
      -- add LazyVim and import its plugins
      -- { "LazyVim/LazyVim", import = "lazyvim.plugins" },
      -- import/override with your plugins
      { import = "plugins" },
    },
    defaults = {
      -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
      -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
      lazy = false,
      -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
      -- have outdated releases, which may break your Neovim install.
      version = false, -- always use the latest git commit
      -- version = "*", -- try installing the latest stable version for plugins that support semver
    },
    -- install = { colorscheme = { "tokyonight", "habamax" } },
    checker = {
      enabled = true, -- check for plugin updates periodically
      notify = false, -- notify on update
    }, -- automatically check for plugin updates
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
