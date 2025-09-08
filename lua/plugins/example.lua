-- Since this is just an example spec, don't actually load anything here and return an empty spec
if true then return {} end

-- Every spec file under the "plugins" directory will be loaded automatically by plugin manager (e.g. lazy.nvim)
--
-- In these plugin spec files, can configure:
-- * disable/enable the plugins imported from plugin repositories
-- * override the configuration for the plugins imported from plugin repositories
-- * add extra plugins
--
-- See the documentation for more details. (URL: https://lazy.folke.io/spec)

return {

  --[[ Plugin Spec Properties: ]]
  --[[ ==> Begin:
  {
    ## 1. Spec Source
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    | Property      | Type                                | Description                                                                                           |
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    | [1]           | string                              | Short plugin url. Will be expanded using '#config.git.url_format'. Can also be a @url or @dir.        |
    | dir           | string                              | A directory pointing to a local plugin                                                                |
    | url           | string                              | A custom git url where the plugin is hosted                                                           |
    | name          | string                              | A custom name for the plugin used for the local plugin directory and as the display name              |
    | dev           | boolean                             | When 'true', a local plugin directory will be used instead. See '#config.dev'                         |
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    A valid spec should define one of @[1], @dir or @url.

    ## 2. Spec Loading
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    | Property      | Type                                | Description                                                                                           |
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    | dependencies  | LazySpec[]                          | A list of plugin names or plugin specs that should be loaded when the plugin loads. Dependencies are  |
    |               |                                     | always lazy-loaded unless specified otherwise. When specifying a name, make sure the plugin spec has  |
    |               |                                     | been defined somewhere else.                                                                          |
    | enabled       | boolean or fun():boolean            | When 'false', or if the 'function' returns false, then this plugin will not be included in the spec   |
    | cond          | boolean or fun(LazyPlugin):boolean  | Behaves the same as @enabled, but won't uninstall the plugin when the condition is 'false'. Useful to |
    |               |                                     | disable some plugins in vscode, or firenvim for example.                                              |
    | priority      | number                              | Only useful for start plugins ('@lazy=false') to force loading certain plugins first. Default priority|
    |               |                                     | is '50'. It's recommended to set this to a high number for colorschemes.                              |
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+

    ## 3. Spec Setup
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    | Property      | Type                                | Description                                                                                           |
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    | init          | fun(LazyPlugin)                     | @init functions are always executed during startup. Mostly useful for setting 'vim.g.*' configuration |
    |               |                                     | used by Vim plugins startup                                                                           |
    | opts          | table or fun(LazyPlugin, opts:table)| @opts should be a table (will be merged with parent specs), return a table (replaces parent specs) or |
    |               |                                     | should change a table. The table will be passed to the 'Plugin.config()' function. Setting this value |
    |               |                                     | will imply 'Plugin.config()'                                                                          |
    | config        | fun(LazyPlugin, opts:table) or true | @config is executed when the plugin loads. The default implementation will automatically run          |
    |               |                                     | 'require(MAIN).setup(opts)' if @opts or '@config = true' is set. Lazy uses several heuristics to      |
    |               |                                     | determine the plugin's 'MAIN' module automatically based on the plugin's name.                        |
    |               |                                     | (@opts is the recommended way to configure plugins).                                                  |
    | main          | string                              | You can specify the @main module to use for '@config()' and '@opts()', in case it can not be          |
    |               |                                     | determined automatically. See '@config()'                                                             |
    | build         | fun(LazyPlugin) or string           | @build is executed when a plugin is installed or updated. See '#Building' for more information.       |
    |               | or a list of build commands         |                                                                                                       |
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    Always use @opts instead of #config when possible. @config is almost never needed.
    Good: { "folke/todo-comments.nvim", opts = {} },
    Bad: {
      "folke/todo-comments.nvim",
      config = function()
      require("todo-comments").setup({})
      end,
    },

    ## 4. Spec Lazy Loading
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    | Property      | Type                                | Description                                                                                           |
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    | lazy          | boolean                             | When 'true', the plugin will only be loaded when needed. Lazy-loaded plugins are automatically loaded |
    |               |                                     | when their Lua modules are 'required', or when one of the lazy-loading handlers triggers              |
    | event         | string or string[]                  | Lazy-load on event. Events can be specified as 'BufEnter' or with a pattern like 'BufEnter *.lua'     |
    |               | or fun(self:LazyPlugin,             |                                                                                                       |
    |               |        event:string[]):string[]     |                                                                                                       |
    |               | or {event:string[]|string,          |                                                                                                       |
    |               |     pattern?:string[]|string}       |                                                                                                       |
    | cmd           | string or string[]                  | Lazy-load on command                                                                                  |
    |               | or fun(self:LazyPlugin,             |                                                                                                       |
    |               |        cmd:string[]):string[]       |                                                                                                       |
    | ft            | string or string[]                  | Lazy-load on filetype                                                                                 |
    |               | or fun(self:LazyPlugin,             |                                                                                                       |
    |               |        ft:string[]):string[]        |                                                                                                       |
    | keys          | string or string[] or LazyKeysSpec[]| Lazy-load on '#key mapping'                                                                           |
    |               | or fun(self:LazyPlugin,             |                                                                                                       |
    |               |        keys:string[])               |                                                                                                       |
    |               |    :(string | LazyKeysSpec)[]       |                                                                                                       |
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    Refer to the '#Lazy Loading' section for more information.

    ## 5. Spec Versioning
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    | Property      | Type                                | Description                                                                                           |
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    | branch        | string                              | Branch of the repository                                                                              |
    | tag           | string                              | Tag of the repository                                                                                 |
    | commit        | string                              | Commit of the repository                                                                              |
    | version       | string or false                     | Version to use from the repository. Full '#Semver' ranges are supported                               |
    | pin           | boolean                             | When 'true', this plugin will not be included in updates                                              |
    | submodules    | boolean                             | When 'false', git submodules will not be fetched. Defaults to 'true'                                  |
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    Refer to the '#Versioning' section for more information.

    ## 6. Spec Advanced
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    | Property      | Type                                | Description                                                                                           |
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
    | optional      | boolean                             | When a spec is tagged optional, it will only be included in the final spec, when the same plugin has  |
    |               |                                     | been specified at least once somewhere else without @optional. This is mainly useful for Neovim       |
    |               |                                     | distros, to allow setting options on plugins that may/may not be part of the user's plugins.          |
    | specs         | LazySpec                            | A list of plugin specs defined in the scope of the plugin. This is mainly useful for Neovim distros,  |
    |               |                                     | to allow setting options on plugins that may/may not be part of the user's plugins. When the plugin   |
    |               |                                     | is disabled, none of the scoped specs will be included in the final spec. Similar to @dependencies    |
    |               |                                     | without the automatic loading of the specs.                                                           |
    | module        | false                               | Do not automatically load this Lua module when it's required somewhere                                |
    | import        | string                              | Import the given spec module.                                                                         |
    +---------------+-------------------------------------+-------------------------------------------------------------------------------------------------------+
  },
  <== End ]]


  --[[ Plugin Spec Examples: ]]

  -- the colorscheme should be available when starting Neovim
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- I have a separate config.mappings file where I require which-key.
  -- With lazy the plugin will be automatically loaded when it is required somewhere
  { "folke/which-key.nvim", lazy = true },

  {
    "nvim-neorg/neorg",
    -- lazy-load on filetype
    ft = "norg",
    -- options for neorg. This will automatically call `require("neorg").setup(opts)`
    opts = {
      load = {
        ["core.defaults"] = {},
      },
    },
  },

  {
    "dstein64/vim-startuptime",
    -- lazy-load on a command
    cmd = "StartupTime",
    -- init is called during startup. Configuration for vim plugins typically should be set in an init function
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      -- ...
    end,
  },

  -- if some code requires a module from an unloaded plugin, it will be automatically loaded.
  -- So for api plugins like devicons, we can always set lazy=true
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- you can use the VeryLazy event for things that can
  -- load later and are not important for the initial UI
  { "stevearc/dressing.nvim", event = "VeryLazy" },

  {
    "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },

  {
    "monaqa/dial.nvim",
    -- lazy-load on keys
    -- mode is `n` by default. For more advanced options, check the section on key mappings
    keys = { "<C-a>", { "<C-x>", mode = "n" } },
  },

  -- local plugins need to be explicitly configured with dir
  { dir = "~/projects/secret.nvim" },

  -- you can use a custom url to fetch a plugin
  { url = "git@github.com:folke/noice.nvim.git" },

  -- local plugins can also be configured with the dev option.
  -- This will use {config.dev.path}/noice.nvim/ instead of fetching it from GitHub
  -- With the dev option, you can easily switch between the local and installed version of a plugin
  { "folke/noice.nvim", dev = true },

  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- disable trouble
  { "folke/trouble.nvim", enabled = false },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
      },
    },
  },

  -- add tsserver and setup with typescript.nvim instead of lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver will be automatically installed with mason and loaded with lspconfig
        tsserver = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },

  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
    end,
  },

  -- the opts function can also be used to change the default opts:
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return "😄"
        end,
      })
    end,
  },

  -- or you can return new options to override all the defaults
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        --[[add your custom lualine config here]]
      }
    end,
  },

  -- use mini.starter instead of alpha
  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
}
