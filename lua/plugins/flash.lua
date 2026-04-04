return {

  -- Flash enhances the built-in search functionality by showing labels at the end of each match, letting you quickly jump to a specific location.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {},
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require("flash").jump() end, desc = "Flash Jump" },
      { 'S', mode = { 'n', 'x', 'o' }, function() require("flash").treesitter() end, desc = "Flash Selection (Treesitter)" },
      { 'R', mode = { 'o', 'x' }, function() require("flash").treesitter_search() end, desc = "Flash Search and Selection (Treesitter)" },
      { 'r', mode = 'o', function() require("flash").remote() end, desc = "Flash Remote Operator (d,y)" },
      { '<C-s>', mode = { 'c' }, function() require("flash").toggle() end, desc = "Flash Toggle for Search Command-line (/,?,:)" },
    },
  },

}
