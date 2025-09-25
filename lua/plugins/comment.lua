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
      -- \cA(switch alternative delimiter)
	  -- \cb(line or selected line comment)
	  -- \cc(line or selected block comment)
	  -- \cm(block comment use one /**/)
	  -- \cu(uncomment)
	  -- \ca(append comment end of line)
	  -- \cs(style comment)

      vim.keymap.set({ 'n', 'x' }, '<Leader>cc', "<Plug>NERDCommenterComment", { desc = "" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>cb', "<Plug>NERDCommenterAlignBoth", { desc = "" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>cl', "<Plug>NERDCommenterAlignLeft", { desc = "" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>cs', "<Plug>NERDCommenterSexy", { desc = "" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>cm', "<Plug>NERDCommenterMinimal", { desc = "" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>cy', "<Plug>NERDCommenterYank", { desc = "" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>cn', "<Plug>NERDCommenterNested", { desc = "" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>cu', "<Plug>NERDCommenterUncomment", { desc = "" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>ci', "<Plug>NERDCommenterInvert", { desc = "" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>c<Space>', "<Plug>NERDCommenterToggle", { desc = "" })
      vim.keymap.set('n', '<Leader>c$', "<Plug>NERDCommenterToEOL", { desc = "" })
      vim.keymap.set('n', '<Leader>ca', "<Plug>NERDCommenterAppend", { desc = "" })
      vim.keymap.set('n', '<Leader>cA', "<Plug>NERDCommenterAltDelims", { desc = "" })

    end,
  },

}
