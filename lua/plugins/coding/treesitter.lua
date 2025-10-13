return {

  -- The nvim-treesitter wraps the Neovim treesitter API to support treesitter configurations and abstraction layer for Neovim
  -- Provide highlighting, indenting, incremental selection, and commands to easily install grammar parsers
  {
    'nvim-treesitter/nvim-treesitter',
    -- See `:h nvim-treesitter and :h treesitter` for more help information
    build = ':TSUpdate', -- Automatically update parsers for each pull
    opts = {
      ensure_installed = { -- List of ensure installed languages parser names, or "all"
        'asm',
        'bash',
        'bp',
        'c',
        'cmake',
        'cpp',
        'diff',
        'html',
        'java',
        'json',
        'lua',
        'luadoc',
        'make',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'vim',
        'vimdoc'
      },
      sync_install = false, -- Install parsers synchronously (only applied to `ensure_installed`)
      auto_install = true, -- Automatically install missing parsers when entering buffer
      ignore_install = {}, -- List of parsers to ignore installing (for "all")
      highlight = {
        enable = true,
        disable = {}, -- List of language that will be disabled
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        -- If you are experiencing weird indenting issues, add the language to the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = {
        -- enable = true, -- TODO: not friendly to me
        disable = { -- List of language that will be disabled
          'ruby',
        },
      },
      incremental_selection = { -- Incremental selection based on the named nodes from the grammar tree
        enable = true,
        keymaps = {
          init_selection = "v<Space>",  -- In normal mode, start incremental selection
          node_incremental = "<Space>", -- In visual mode, increment to the upper named parent
          scope_incremental = false,    -- In visual mode, increment to the upper bscope
          node_decremental = "<BS>",    -- In visual mode, decrement to the previous named node
        },
      },
    },
    config = function(_, opts)
      local ok, ts = pcall(require, 'nvim-treesitter.configs')
      if ok then
        ts.setup(opts)
        vim.opt.foldmethod = 'expr' -- Update fold options after treesitter highlight enabled, because legacy syntax highlighting has become inactived
        -- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
        vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      end
    end,
  },

  -- There are additional nvim-treesitter modules that you can use to interact with nvim-treesitter. You should go explore a few and see what interests you:
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

}
