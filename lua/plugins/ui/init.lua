-- TODO: Try using 'bufferline'
vim.g.tabline = 'lualine' -- Possible values: 'lualine', 'bufferline'
vim.g.tabline_show = 0    -- 0: windows, 1: buffers
vim.keymap.set('n', '<Leader>t<Space>', function()
  if vim.g.tabline_show == 0 then
    vim.g.tabline_show = 1
  else
    vim.g.tabline_show = 0
  end
  if vim.g.tabline == 'lualine' then
    local ok, lualine = pcall(require, 'lualine')
    if not ok then return end
    lualine.refresh({
      scope = 'tabpage',
      place = { 'tabline' },  -- lualine segment ro refresh
    })
  end
end, { desc = "Tab Page Switch Source (Windows / Buffers)" })

return {}
