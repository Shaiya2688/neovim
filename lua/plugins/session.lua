return {

  -- solution 1
  -- {
  --   "rmagatti/auto-session",
  --   lazy = false,  -- 确保立即加载
  --   config = function()
  --     require("auto-session").setup({
  --       -- 核心自动功能
  --       auto_save = true,           -- 退出时自动保存
  --       auto_restore = true,        -- 启动时自动恢复
  --       auto_create = true,         -- 新目录自动创建会话

  --       -- 排除特定目录（避免在家目录等创建会话）
  --       suppressed_dirs = { "~/", "~/Downloads", "~/Desktop", "/" },

  --       -- 会话存储位置
  --       root_dir = vim.fn.stdpath("data") .. "/sessions/",

  --       -- 可选：Git 分支感知（不同分支不同会话）
  --       use_git_branch = false,

  --       -- 可选：关闭不支持的窗口类型
  --       close_unsupported_windows = true,
  --     })

  --     -- 手动控制快捷键（可选）
  --     vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "恢复会话" })
  --     vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "保存会话" })
  --   end,
  -- },

  -- solution 2
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>sl", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ss", function() require("persistence").select() end,desc = "Select Session" },
      { "<leader>sL", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>sq", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
}
