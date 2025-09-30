vim.g.indentline_exclude_filetypes = {
  "help",
  "lazy",
  "neo-tree",
}
vim.g.indentline_exclude_buftypes = {
  "terminal",
  "help",
  "nofile",
  "quickfix",
  "prompt",
}
vim.keymap.set('n', '<Leader>i<Space>', function()
  vim.b.indentline_disable = not vim.b.indentline_disable
  -- toggle mini.indentscope
  vim.b.miniindentscope_disable = vim.b.indentline_disable
  local ok, indent = pcall(require, 'mini.indentscope')
  if ok then indent.draw() end
  -- toggle ibl
  ok, indent = pcall(require, 'ibl')
  if ok then indent.setup_buffer(vim.api.nvim_get_current_buf(), { enabled = not vim.b.indentline_disable }) end
end, { desc = "Indent Line Toggle" })

local utils = _utils

return {

  -- Supports for global indentation, will showing static guides of indent levels
  {
    'lukas-reineke/indent-blankline.nvim',
    -- See `:h ibl` for more help information
    event = "VeryLazy",
    main = 'ibl',
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = vim.g.indentline_exclude_filetypes,
        buftypes = vim.g.indentline_exclude_buftypes,
      },
    },
    config = function(_, opts)
      local highlight_setup = function()
        if (vim.g.colors_name == 'shaiya-light' or vim.g.colors_name == 'shaiya-dark') then
          utils.hl.create_group('IblWhitespace', { gui='nocombine', cterm='nocombine', fg=254, })
          utils.hl.create_group('IblIndent', { gui='nocombine', cterm='nocombine', fg=254, })
          utils.hl.create_group('IblScope', { gui='nocombine', cterm='nocombine', fg=250, })
        end
      end
      local ok, hooks = pcall(require, 'ibl.hooks')
      if ok then
        hooks.register(hooks.type.HIGHLIGHT_SETUP, highlight_setup) -- Reset highlight groups when colorscheme changes
      end
      ok, indent = pcall(require, 'ibl')
      if ok then
        indent.setup(opts)
      end
    end
  },

  -- Supports for scope indentation, will visualize scope with animated vertical line, and can operate the textobjects on scope
  {
    'echasnovski/mini.indentscope',
    -- See `:h mini.indentscope` for more help information
    event = "VeryLazy",
    opts = {
      draw = {
        delay = 100, -- delay (in ms) between event and start of drawing scope indicator, affecting drawing when the cursor moves rapidly
        animation = function() return 0 end, -- returns wait time (in ms) border drawing step lines, 0 to disable animation
      },
      mappings = {
        -- type 'vii' or 'vai' to select texts for scope
        object_scope = 'ii',
        object_scope_with_border = 'ai',
        -- type '[i' or ']i' to jump to respective border line; type 'v[i' or 'v]i' to jump and select texts
        goto_top = '[i',
        goto_bottom = ']i',
      },
      -- Options which control scope computation
      options = {
        border = 'both', -- type of scope's border, can be one of: 'both', 'top', 'bottom', 'none'
        indent_at_cursor = true, -- Computing reference indent when cursor moves horizontally.
        try_as_border = true, -- Enable place cursor on function header to get scope of its body.
      },
      symbol = '│', -- use for drawing scope indicator
    },
    config = function(_, opts)
      local highlight_setup = function()
        utils.hl.create_group('MiniIndentscopeSymbol', { gui='nocombine', cterm='nocombine', fg=248, })
      end
      utils.hl.on_colorscheme_changed(highlight_setup, true) -- Reset highlight groups when colorscheme changes
      local ok, indent = pcall(require, 'mini.indentscope')
      if ok then
        indent.setup(opts)
        highlight_setup()
      end
      vim.api.nvim_create_autocmd("FileType", {
        pattern = vim.g.indentline_exclude_filetypes,
        callback = function()
          if vim.b.indentline_disable == nil then
            vim.b.indentline_disable = true
            vim.b.miniindentscope_disable = true
          end
        end,
      })
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          if vim.tbl_contains(vim.g.indentline_exclude_buftypes, vim.bo.buftype) and vim.b.indentline_disable == nil then
            vim.b.indentline_disable = true
            vim.b.miniindentscope_disable = true
          end
        end,
      })
    end
  },

}
