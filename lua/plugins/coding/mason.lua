return {

  -- Allows you to easily manage external editor tooling such as LSP servers, DAP servers, Linters, and Formatters
  {
    'mason-org/mason.nvim',
    -- See `:h mason` for more help information
    keys = {
      { '<C-F10>', "<Cmd>Mason<Cr>", desc = "Open Mason Package Manager" },
      { '<F34>', "<C-F10>", remap = true, desc = "Open Mason Package Manager" }, -- <C-F10> will be converted to <F34> if Neovim is not under gui running
    },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
      ui = {
        icons = vim.g.have_nerd_fonts and {
          package_installed = "✓",
          package_uninstalled = "◍",
          package_pending = "",
        } or {
          package_installed = "✓",
          package_uninstalled = "◍",
          package_pending = "⟳",
        },
        keymaps = {
          toggle_help = "?",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      -- local mr = require("mason-registry")
      -- mr:on("package:install:success", function()
      --   vim.defer_fn(function()
      --     -- trigger FileType event to possibly load this newly installed LSP server
      --     require("lazy.core.handler.event").trigger({
      --       event = "FileType",
      --       buf = vim.api.nvim_get_current_buf(),
      --     })
      --   end, 100)
      -- end)

      -- mr.refresh(function()
      --   for _, tool in ipairs(opts.ensure_installed) do
      --     local p = mr.get_package(tool)
      --     if not p:is_installed() then
      --       p:install()
      --     end
      --   end
      -- end)
    end,
  },

  -- This is a simple plugin that helps users keep up-to-date with their tools to make certain they have a consistent environment
  -- It will automatically install or upgrade all of packages which installed via `mason`, and can integrate plugins: 'mason-lspconfig', 'mason-null-ls', 'mason-nvim-dap'
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- See `:h mason-tool-installer` or README for more help information
    dependencies = {
      'mason-org/mason.nvim',
    },
    cmd = {
      "MasonToolsInstall",
      "MasonToolsInstallSync",
      "MasonToolsUpdate",
      "MasonToolsUpdateSync",
      "MasonToolsClean",
    },
    opts = {
      ensure_installed = { -- a list of all tools you want to ensure are installed upon start
        -- { 'bash-language-server', auto_update = true }, -- you can turn off/on auto_update per tool
        -- "stylua",
        -- "shfmt",
      },
      auto_update = true,
      debounce_hours = 5, -- at least 5 hours between attempts to install/update
      run_on_start = true,
      start_delay = 3000, -- 3 second delay
      integrations = {
        ["mason-lspconfig"] = false,
        ["mason-null-ls"] = false,
        ["mason-nvim-dap"] = false,
      },
    },
    config = function(_, opts)
      local ok, mti = pcall(require, 'mason-tool-installer')
      if ok then
        -- Don't setup opts here, using mason-tool-installer to automatically install or update only needed when explicitly required
        mti.setup({
          ensure_installed = nil,
          auto_update = false,
          run_on_start = false,
        })
      end
    end,
  },

  -- Bridge `nvim-lspconfig` to `mason.nvim`, translate names between `nvim-lspconfig` server names and `mason.nvim` package names (e.g. `lua_ls <-> lua-language-server`)
  {
    'mason-org/mason-lspconfig.nvim',
    -- See `:h mason-lspconfig` for more help information
    dependencies = {
      'mason-org/mason.nvim',
    },
    cmd = {
      "LspInstall",
      "LspUninstall",
    },
    opts = {
      ensure_installed = {}, -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
      automatic_enable = true, -- Whether installed servers should automatically be enabled via `:h vim.lsp.enable()`
    },
    config = function(_, opts)
      local ok, mlspc = pcall(require, 'mason-lspconfig')
      if ok then
        -- Don't setup here, `mason-lspconfig` loading require `nvim-lspconfig` have available in Neovim's runtimepath
        -- mlspc.setup({
        --   ensure_installed = nil,
        --   automatic_enable = false,
        -- })
      end
    end,
  },

  -- Bridge `null-ls` to `mason.nvim`, translate names between `null-ls` source names and `mason.nvim` package names (e.g. `haml_lint` <-> `haml-lint`)
  {
    'jay-babu/mason-null-ls.nvim',
    -- See `:h mason-null-ls` or README for more help information
    dependencies = {
      'mason-org/mason.nvim',
    },
    cmd = {
      "NullLsInstall",
      "NullLsUninstall",
      "NoneLsInstall",
      "NoneLsUninstall",
    },
    opts = {
      ensure_installed = {}, -- A list of sources to install if they're not already installed.
      automatic_installation = true, -- Run `require("null-ls").setup` will automatically install masons tools based on selected sources in `null-ls`
    },
    -- Don't setup here, `mason-null-ls` loading require `null-ls` have available in Neovim's runtimepath
    config = function() end,
  },

  -- Bridge `nvim-dap` to `mason.nvim`, translate names between `nvim-dap` adapter names and `mason.nvim` package names (e.g. `python` <-> `debugpy`)
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- See `:h mason-nvim-dap` or README for more help information
    dependencies = {
      'mason-org/mason.nvim',
    },
    cmd = {
      "DapInstall",
      "DapUninstall"
    },
    opts = {
      ensure_installed = {}, -- A list of adapters to install if they're not already installed
      automatic_installation = true, -- Whether adapters that are set up (via dap) should be automatically installed if they're not already installed
    },
    -- Don't setup here, `mason-nvim-dap` loading require `nvim-dap` have available in Neovim's runtimepath
    config = function() end,
  },

}
