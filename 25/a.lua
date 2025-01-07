require('utils')

local function parseInput()
  local locks = {}
  local keys = {}
  local getLine = readInput()
  while true do
    local firstLine = getLine()
    local isKey = firstLine == '.....'
    local values = { 0, 0, 0, 0, 0 }

    for _ = 1, 5 do
      local line = stringSplit(getLine(), '')
      for i, v in ipairs(line) do
        if v == '#' then values[i] = values[i] + 1 end
      end
    end

    getLine()

    if isKey then
      table.insert(keys, values)
    else
      table.insert(locks, values)
    end

    if getLine() == nil then
      break
    end
  end

  return locks, keys
end

local function canFit(lock, key)
  for i = 1, 5 do
    if lock[i] + key[i] > 5 then return false end
  end
  return true
end

local locks, keys = parseInput()

local total = 0

for _, lock in ipairs(locks) do
  for _, key in ipairs(keys) do
    if canFit(lock, key) then
      total = total + 1
    end
  end
end

print(total)
