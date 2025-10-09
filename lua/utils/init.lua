local M = {}

function M.setup()
  setmetatable(M, {
    __index = function(t, k)
      local _k = k
      if k == 'hl' then
        _k = 'highlight'
      end
      t[k] = require('utils.' .. _k)
      return t[k]
    end,
  })
end

M.setup()

return M
