function readInput()
  local isTest = arg[1] == 'test' or arg[1] == 't'
  local dir = arg[0]:match("(.*[/\\])")
  local filename = dir .. 'input.txt'

  if isTest then
    filename = dir .. 'testinput.txt'
  end

  return io.lines(filename)
end

local defaultValueKey = {}
setmetatable(defaultValueKey, { __tostring = function() return '{default value}' end })
local defaultValueMetatable = { __index = function(t) return t[defaultValueKey] end }
function setDefault(t, d)
  t[defaultValueKey] = d
  setmetatable(t, defaultValueMetatable)
end

---@type fun(str: string, delimiter: string): table
function stringSplit(str, delimiter)
  local arr = {}
  local findStart = 1

  if str == '' then
    return { '' }
  end

  while findStart <= str:len() do
    local s, e = str:find(delimiter, findStart)
    if s and e then
      table.insert(arr, str:sub(findStart, s - 1))
      findStart = e + 1
      if findStart == str:len() + 1 then
        table.insert(arr, '')
        break
      end
    else
      table.insert(arr, str:sub(findStart, str:len()))
      break
    end
  end

  return arr
end

---@type fun(tab: table, fn: function): table
function map(tab, fn)
  local newTable = {}
  for k, v in pairs(tab) do
    newTable[k] = fn(v)
  end
  return newTable
end

-- From https://stackoverflow.com/a/27028488
-- Modified by me
local function anythingToString(o, level)
  if type(o) == 'table' then
    local s = '{\n'
    for k, v in pairs(o) do
      if type(k) == 'string' then
        k = '"' .. k .. '"'
      else
        k = tostring(k)
      end
      s = s .. string.rep('  ', level + 1) .. '[' .. k .. '] = ' .. anythingToString(v, level + 1) .. ',\n'
    end
    return s .. string.rep('  ', level) .. '}'
  else
    return tostring(o)
  end
end

-- It's like print, but cooler
function dump(o)
  print(anythingToString(o, 0))
end
