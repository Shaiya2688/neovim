return {

  -- Provides many different commenting operations and styles
  {
    "preservim/nerdcommenter",
    -- See `:h nerdcommenter` for more help information
    event = "VeryLazy",
    init = function()
      vim.g.NERDCreateDefaultMappings = 0   -- Disable default mappings
      vim.g.NERDSpaceDelims = 1             -- Add spaces after comment delimiters by default
      vim.g.NERDCompactSexyComs = 0         -- Use compact syntax for prettified multi-line comments
      vim.g.NERDDefaultAlign = 'both'       -- Align line-wise comment delimiters flush left instead of following code indentation
      vim.g.NERDTrimTrailingWhitespace = 1  -- Enable trimming of trailing whitespace when uncommenting
      vim.g.NERDToggleCheckAllLines = 1     -- Enable NERDCommenterToggle to check all selected lines is commented or not
      vim.g.NERDAltDelims_java = 1          -- Set a language to use its alternate delimiters by default
      vim.g.NERDCommentEmptyLines = 0       -- Set true to allow commenting and inverting empty lines (useful when commenting a region)
      vim.g.NERDLPlace="/*"                 -- Specifies what to use as the left delimiter placeholder when nesting comments, plugin default: "[>".
      vim.g.NERDRPlace="*/"                 -- Specifies what to use as the left delimiter placeholder when nesting comments, plugin default: "<]".
    end,
    config = function()
      vim.keymap.set({ 'n', 'x' }, '<Leader>cc', "<Plug>NERDCommenterComment",      { desc = "Comment Current Line or Selected Text" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>cy', "<Plug>NERDCommenterYank",         { desc = "Comment Current Line or Selected Text (Yank First)" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>cn', "<Plug>NERDCommenterNested",       { desc = "Comment Current Line or Selected Text (Nested)" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>cb', "<Plug>NERDCommenterAlignBoth",    { desc = "Comment Current Line or Selected Lines (Align The Both Left and Right Delimiters)" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>cl', "<Plug>NERDCommenterAlignLeft",    { desc = "Comment Current Line or Selected Lines (Only Align The Left Delimiters)" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>cs', "<Plug>NERDCommenterSexy",         { desc = "Comment Current Line or Selected Lines (Pretty Block Style)" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>cm', "<Plug>NERDCommenterMinimal",      { desc = "Comment Current Line or Selected Lines (Using Multipart Delimiters)" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>cu', "<Plug>NERDCommenterUncomment",    { desc = "Uncomment Current Line or Selected Lines" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>ci', "<Plug>NERDCommenterInvert",       { desc = "Toggle Comments of Current Line or Selected Lines" })
      vim.keymap.set({ 'n', 'x' }, '<Leader>c<Space>', "<Plug>NERDCommenterToggle", { desc = "Toggle Comments of Current Line or Selected Lines (Based On The First Selected Line)" })
      vim.keymap.set('n', '<Leader>c$', "<Plug>NERDCommenterToEOL",                 { desc = "Comment Texts From Cursor To EOL" })
      vim.keymap.set('n', '<Leader>ca', "<Plug>NERDCommenterAppend",                { desc = "Append Comment At EOL, And Start Insert" })
      vim.keymap.set('n', '<Leader>cA', "<Plug>NERDCommenterAltDelims",             { desc = "Switch Comment To Using Alternative Delimiters" })
    end,
  },

}
