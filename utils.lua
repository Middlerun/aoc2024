function isTest()
  return arg[1] == 'test' or arg[1] == 't'
end

function readInput()
  local dir = arg[0]:match("(.*[/\\])")
  local filename = dir .. 'input.txt'

  if isTest() then
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

function readGridInput(tileMapperFn)
  local rows = {}

  local y = 0
  for line in readInput() do
    y = y + 1
    local row = stringSplit(line, '')

    if tileMapperFn then
      row = map(row, tileMapperFn)
    end

    table.insert(rows, row)
  end

  return rows
end

---@type fun(str: string, delimiter: string): table
function stringSplit(str, delimiter)
  local arr = {}
  local findStart = 1

  if str == '' then
    return { '' }
  end

  if delimiter == '' then
    for i = 1, str:len() do
      table.insert(arr, str:sub(i, i))
    end
  else
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
  end

  return arr
end

---@type fun(tab: table, fn: function): table
function map(tab, fn)
  local newTable = {}
  for k, v in pairs(tab) do
    newTable[k] = fn(v, k)
  end
  return newTable
end

---@generic T
---@type fun(arr: T[], fn: fun(v: T, k: any): boolean): T[]
function filter(tab, fn)
  local newArr = {}
  for k, v in pairs(tab) do
    if fn(v, k) then
      table.insert(newArr, v)
    end
  end
  return newArr
end

---@type fun(arr: table, fn: function): any, number
function findWhere(arr, fn)
  for i, v in ipairs(arr) do
    if fn(v) then return v, i end
  end
  return nil, -1
end

---@type fun(arr: table, fn: function): any, number, number
function minBy(arr, fn)
  local min = {}
  local minVal = math.huge
  local minIndex
  for i, v in ipairs(arr) do
    local val = fn(v)
    if val < minVal then
      min = v
      minVal = val
      minIndex = i
    end
  end
  return min, minVal, minIndex
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

---@param grid string[][] An array of arrays of single characters
---@param mapFn fun(value: string, x: number, y: number): string An optional function to map the characters. Called with the value and the x and y coordinates.
---@overload fun(grid: string[][])
function printGrid(grid, mapFn)
  for y, row in ipairs(grid) do
    local mappedRow = map(row, function(v, x)
      if mapFn then
        return mapFn(v, x, y)
      else
        return v
      end
    end)
    print(table.concat(mappedRow, ''))
  end
end

function shallowClone(x)
  if type(x) == 'table' then
    return map(x, function(y) return y end)
  else
    return x
  end
end

function shallowClone(x)
  return map(x, function(v) return v end)
end

function deepClone(x)
  if type(x) == 'table' then
    return map(x, deepClone)
  else
    return x
  end
end

function pickKeys(o, keys)
  local newObj = {}
  for _, k in ipairs(keys) do
    newObj[k] = o[k]
  end
  return newObj
end

---@generic T
---@param t T[]
---@param fn fun(item: T): boolean
---@return integer
function countWhere(t, fn)
  local total = 0
  for _, v in pairs(t) do
    if fn(v) then total = total + 1 end
  end
  return total
end

---@type fun(sourceArr: table, startIndex: number, lengthToRemove: number, elementsToInsert: table): table
function spliceArray(sourceArr, startIndex, lengthToRemove, elementsToInsert)
  local indicesAddedCount = #elementsToInsert - lengthToRemove
  local indicesRemovedCount = lengthToRemove - #elementsToInsert
  local arr = shallowClone(sourceArr)

  if indicesAddedCount > 0 then
    for _ = 1, indicesAddedCount do
      table.insert(arr, startIndex, nil)
    end
  elseif indicesRemovedCount > 0 then
    for _ = 1, indicesRemovedCount do
      table.remove(arr, startIndex)
    end
  end

  for i = 1, #elementsToInsert do
    arr[startIndex + i - 1] = elementsToInsert[i]
  end

  return arr
end

function round(num)
  local int, frac = math.modf(num)
  if frac >= 0.5 then
    return int + 1
  end
  return int
end

--- Convenience function, so the function can be used without having to worry about
--- a second argument inadvertently being used as the base
function toNumberBase10(n)
  return tonumber(n)
end

function arraysEqual(a, b)
  if #a ~= #b then return false end
  for i, v in ipairs(a) do
    if v ~= b[i] then return false end
  end
  return true
end

function arrayReverse(arr)
  local newArr = {}
  local len = #arr
  for i = 1, #arr do
    newArr[i] = arr[len - i + 1]
  end
  return newArr
end
