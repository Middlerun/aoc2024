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
local defaultValueMetatable = { __index = function(t) return t[defaultValueKey] end }
function setDefault(t, d)
  t[defaultValueKey] = d
  setmetatable(t, defaultValueMetatable)
end

-- From https://stackoverflow.com/a/27028488
-- Modified by me
local function anythingToString(o, level)
  if type(o) == 'table' then
    local s = '{\n'
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
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
