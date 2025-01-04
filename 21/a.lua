require('utils')
require('vec2')

---@alias Action '^' | '>' | '<' | 'v' | 'A'

UP = '^'
DOWN = 'v'
LEFT = '<'
RIGHT = '>'

DIRECTIONS = {
  [UP] = { x = 0, y = -1 },
  [DOWN] = { x = 0, y = 1 },
  [RIGHT] = { x = 1, y = 0 },
  [LEFT] = { x = -1, y = 0 },
}

local numericKeyPositions = {
  A = Vec2:new(3, 4),
  ['0'] = Vec2:new(2, 4),
  ['1'] = Vec2:new(1, 3),
  ['2'] = Vec2:new(2, 3),
  ['3'] = Vec2:new(3, 3),
  ['4'] = Vec2:new(1, 2),
  ['5'] = Vec2:new(2, 2),
  ['6'] = Vec2:new(3, 2),
  ['7'] = Vec2:new(1, 1),
  ['8'] = Vec2:new(2, 1),
  ['9'] = Vec2:new(3, 1),
}

local arrowKeyPositions = {
  A = Vec2:new(3, 1),
  [UP] = Vec2:new(2, 1),
  [LEFT] = Vec2:new(1, 2),
  [DOWN] = Vec2:new(2, 2),
  [RIGHT] = Vec2:new(3, 2),
}

local function insertVerticals(actions, from, to)
  if to.y < from.y then
    for _ = 1, (from.y - to.y) do table.insert(actions, UP) end
  elseif to.y > from.y then
    for _ = 1, (to.y - from.y) do table.insert(actions, DOWN) end
  end
end

local function insertHorizontals(actions, from, to)
  if to.x < from.x then
    for _ = 1, (from.x - to.x) do table.insert(actions, LEFT) end
  elseif to.x > from.x then
    for _ = 1, (to.x - from.x) do table.insert(actions, RIGHT) end
  end
end

---@param fromKey string
---@param toKey string
---@return Action[]
local function numericKeyActions(fromKey, toKey)
  local actions = {}
  local from = numericKeyPositions[fromKey]
  local to = numericKeyPositions[toKey]

  if from.y == 4 and to.x == 1 then
    insertVerticals(actions, from, to)
    insertHorizontals(actions, from, to)
  else
    insertHorizontals(actions, from, to)
    insertVerticals(actions, from, to)
  end

  table.insert(actions, 'A')

  return actions
end

---@param fromKey string
---@param toKey string
---@return Action[]
local function arrowKeyActions(fromKey, toKey)
  local actions = {}
  local from = arrowKeyPositions[fromKey]
  local to = arrowKeyPositions[toKey]

  if from.y == 1 and to.x == 1 then
    insertVerticals(actions, from, to)
    insertHorizontals(actions, from, to)
  else
    insertHorizontals(actions, from, to)
    insertVerticals(actions, from, to)
  end

  table.insert(actions, 'A')

  return actions
end

---@param sequence string[]
---@param type 'numeric' | 'arrow'
---@return string[]
local function generateNextSequence(sequence, type)
  ---@type fun(fromKey: string, toKey: string): Action[]
  local keyActions
  if type == 'numeric' then
    keyActions = numericKeyActions
  else
    keyActions = arrowKeyActions
  end

  -- Assumption: When this function is called, the current presser's finger is always on the A key
  local currentKey = 'A'
  ---@type string[]
  local newSequence = {}

  for _, nextKey in ipairs(sequence) do
    tableInsertMany(newSequence, keyActions(currentKey, nextKey))
    currentKey = nextKey
  end

  return newSequence
end

local total = 0

for line in readInput() do
  local numericKeys = stringSplit(line, '')

  local arrowKeys1 = generateNextSequence(numericKeys, 'numeric')

  local arrowKeys2 = generateNextSequence(arrowKeys1, 'arrow')

  local arrowKeys3 = generateNextSequence(arrowKeys2, 'arrow')

  local numericCode = tonumber(line:sub(1, -2))
  -- print(#arrowKeys3)
  local complexity = numericCode * #arrowKeys3
  total = total + complexity

  -- if numericCode ~= 3379 then
    -- print(table.concat(numericKeys, ''))
    -- print(table.concat(arrowKeys1, ''))
    -- print(table.concat(arrowKeys2, ''))
    -- print(table.concat(arrowKeys3, ''))
  -- end
end

print(total)

-- This gets the right result for the test input, but not for the real one. No idea why.
