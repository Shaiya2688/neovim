--[[ Utils for Misc ]]
local M = {}

function M.setup()
end

function M.merge_unique(a, b)
  local seen = {}
  local out = {}

  local function add_once(v)
    if seen[v] then return end
    seen[v] = true
    out[#out + 1] = v
  end

  for _, v in ipairs(a) do add_once(v) end
  for _, v in ipairs(b) do add_once(v) end

  return out
end

M.setup()

return M
