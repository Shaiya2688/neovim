--[[ Utils for File operations ]]
local M = {}

function M.setup()
  M.persist_var_file = vim.fn.stdpath('data') .. '/persist_var.json'
  M.persist_var_max_records = 100
end

-- Load persist variables
function M.load_persist_vars()
  local fd = io.open(M.persist_var_file, 'r')
  if not fd then
    return {}
  end

  local ok, obj = pcall(vim.json.decode, fd:read('*a'))
  fd:close()
  if ok and type(obj) == 'table' then
    return obj
  end

  return {}
end

-- Save persist variables
function M.save_persist_vars(vars)
  local cache = {}

  -- sort by timestamp and retain only the latest records
  for name, var in pairs(vars) do
    if type(name == 'string') and name ~= '' and var.value ~= nil and type(var.ts) == 'number' then
      table.insert(cache, { name = name, value = var.value, ts = var.ts })
    end
  end
  table.sort(cache, function(a, b) return a.ts < b.ts end)
  while #cache > M.persist_var_max_records do
    table.remove(cache, 1)
  end

  -- obj: table, { [var_name] = { value = any, ts = number } }
  local obj = {}
  for _, v in ipairs(cache) do
    obj[v.name] = { value = v.value, ts = v.ts }
  end

  local fd, err = io.open(M.persist_var_file, 'w')
  if not fd then
    vim.notify(err, vim.log.levels.ERROR)
    return nil, err
  end
  fd:write(vim.json.encode(obj))
  fd:close()
  return true
end

-- Set or delete persist variable
function M.set_persist_var(name, value)
  if type(name) ~= 'string' or name == '' then
    return nil, "[utils.file.set_var] variable name invalid"
  end

  local vars = M.load_persist_vars()
  vars[name] = { value = value, ts = os.time() }
  M.save_persist_vars(vars)

  return true
end

-- Get persist variable
function M.get_persist_var(name, default)
  if type(name) ~= 'string' or name == '' then
    return default, "[utils.file.set_var] variable name invalid"
  end

  local vars = M.load_persist_vars()
  for n, v in pairs(vars) do
    if n == name then
      return v.value
    end
  end

  return default
end

function M.remove_dir(path)
  local cmd
  if vim.fn.has('win32') or vim.fn.has('win64') then
    cmd = ('rmdir /s /q %s'):format(vim.fn.shellescape(path))
  else
    cmd = ('rm -rf %s'):format(vim.fn.shellescape(path))
  end
  return pcall(vim.fn.system, cmd)
end

M.setup()

return M
