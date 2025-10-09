--[[ Utils for UI ]]
local M = {}

function M.setup()
end

-- Execute ui entry and return a newly opened window and buffer id
function M.new_win_buf(ui_entry)
  if not ui_entry or type(ui_entry) ~= 'function' then
    vim.notify("utils.ui.new_win_buf: invalid ui entry", vim.log.levels.ERROR)
    return nil, nil
  end
  local find_new = function(old_list, new_list)
    local maps = {}
    for _, v in ipairs(old_list) do
      maps[v] = true
    end
    for _, v in ipairs(new_list) do
      if not maps[v] then
        return v
      end
    end
    return nil
  end
  local old_win, old_buf = vim.api.nvim_list_wins(), vim.api.nvim_list_bufs()
  pcall(ui_entry)
  local new_win, new_buf = vim.api.nvim_list_wins(), vim.api.nvim_list_bufs()
  return find_new(old_win, new_win), find_new(old_buf, new_buf)
end

-- Get input from user, it might be an empty string if nothing was entered, or `nil` if the user aborted the dialog
function M.input(prompt)
  local input = nil
  vim.ui.input({ prompt = prompt }, function(pattern)
    input = pattern
  end)
  if input ~= nil then
    vim.cmd('echo ""')
  end
  return input
end

M.setup()

return M
