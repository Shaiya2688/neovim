--[[ Utils for Terminal ]]
local M = {}

function M.setup()
end

-- Open or close window terminal
function M.win_toggle(vsplit)
  if not vim.t.terminal_state then
    vim.t.terminal_state = {
      buf = nil,
    }
  end
  local state = vim.t.terminal_state
  if vim.opt.buftype:get() ~= 'terminal' or vim.api.nvim_get_current_buf() == state.buf then
    local cmd
    if vsplit then
      cmd = "belowright vsplit +terminal" .. ((vim.fn.executable('bash') and " bash") or "")
    else
      cmd = "belowright terminal" .. ((vim.fn.executable('bash') and " bash") or "")
    end
    vim.cmd(cmd)
    -- set first terminal as the tab terminal
    if not state.buf then
      state.buf = vim.api.nvim_get_current_buf()
      vim.t.terminal_state = state
    end
  else
    local buf = vim.api.nvim_get_current_buf()
    local cmd = "quit"
    vim.cmd(cmd)
    vim.api.nvim_buf_delete(buf, { force = true })
  end
end

-- Open or hide tab terminal
function M.tab_toggle(vsplit)
  if not vim.t.terminal_state then
    vim.t.terminal_state = {
      buf = nil,
    }
  end
  local state = vim.t.terminal_state
  if state.buf and not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = nil
  end
  if not state.buf then
    -- terminal no exits
    local cmd
    if vsplit then
      cmd = "belowright vsplit +terminal" .. ((vim.fn.executable('bash') and " bash") or "")
    else
      cmd = "belowright terminal" .. ((vim.fn.executable('bash') and " bash") or "")
    end
    vim.cmd(cmd)
    state.buf = vim.api.nvim_get_current_buf()
  else
    local term_win = nil
    local current_tab = vim.api.nvim_get_current_tabpage()
    local wins = vim.api.nvim_tabpage_list_wins(current_tab)
    for _, win in ipairs(wins) do
      if vim.api.nvim_win_get_buf(win) == state.buf then
        term_win = win
        break
      end
    end
    -- terminal no visible
    if not term_win then
      if vsplit then
        vim.cmd('belowright vsplit')
      else
        vim.cmd('belowright split')
      end
      vim.api.nvim_set_current_buf(state.buf)
      vim.cmd('startinsert')
    else
      -- terminal is visible
      if term_win == vim.api.nvim_get_current_win() then
        vim.cmd('quit')
      else
        vim.api.nvim_win_close(term_win, false)
      end
    end
  end
  vim.t.terminal_state = state
end

M.setup()

return M
