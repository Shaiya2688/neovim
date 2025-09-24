return {

  -- Provides many different commenting operations and styles
  {
    "preservim/nerdcommenter",
    -- See `:h nerdcommenter` for more help information
    event = "VeryLazy",
    init = function()
      vim.g.NERDCreateDefaultMappings = 0
      vim.g.NERDSpaceDelims = 1				-- Add spaces after comment delimiters by default
      vim.g.NERDCompactSexyComs = 1			-- Use compact syntax for prettified multi-line comments
      vim.g.NERDDefaultAlign = 'both' 		-- Align line-wise comment delimiters flush left instead of following code indentation
      vim.g.NERDTrimTrailingWhitespace = 1	-- Enable trimming of trailing whitespace when uncommenting
      vim.g.NERDToggleCheckAllLines = 1		-- Enable NERDCommenterToggle(\c<space>) to check all selected lines is commented or not
      -- NERDLPlace="/*"						-- Specifies what to use as the left delimiter placeholder when nesting comments.
      -- NERDRPlace="*/"						-- Specifies what to use as the left delimiter placeholder when nesting comments.
    end,
    config = function()
      local opts = { noremap = true, silent = true }
      -- \ca(switch alternative delimiter),\cb(line or selected line comment),\cc(line or selected block comment),\cm(block comment use one /**/),\cu(uncomment),\cA(append comment end of line),\cs(style comment), more see :h nerdcommenter or :map
      -- vim.keymap.set({"n", "x"}, "gc", "<Plug>NERDCommenterToggle", opts)
      -- vim.keymap.set("n", "gci", "<Plug>NERDCommenterInvert", opts)

    end,
  },

}
