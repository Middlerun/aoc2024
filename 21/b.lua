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

local arrowKeyMemo = {}

---@param fromKey string
---@param toKey string
---@return integer
local function arrowKeyActions(fromKey, toKey, layer)
  if layer == 0 then
    return 1
  end

  local memoKey = fromKey .. ',' .. toKey .. ',' .. layer

  if arrowKeyMemo[memoKey] then
    return arrowKeyMemo[memoKey]
  end

  local possibleSequences = {}
  local from = arrowKeyPositions[fromKey]
  local to = arrowKeyPositions[toKey]

  if from.y == 1 and to.x == 1 then
    local actions = {}
    insertVerticals(actions, from, to)
    insertHorizontals(actions, from, to)
    table.insert(actions, 'A')
    table.insert(possibleSequences, actions)
  elseif from.x == 1 and to.y == 1 then
    local actions = {}
    insertHorizontals(actions, from, to)
    insertVerticals(actions, from, to)
    table.insert(actions, 'A')
    table.insert(possibleSequences, actions)
  else
    -- try both
    local actionsHorizontalFirst = {}
    insertHorizontals(actionsHorizontalFirst, from, to)
    insertVerticals(actionsHorizontalFirst, from, to)
    table.insert(actionsHorizontalFirst, 'A')
    table.insert(possibleSequences, actionsHorizontalFirst)

    local actionsVerticalFirst = {}
    insertVerticals(actionsVerticalFirst, from, to)
    insertHorizontals(actionsVerticalFirst, from, to)
    table.insert(actionsVerticalFirst, 'A')
    table.insert(possibleSequences, actionsVerticalFirst)
  end

  local expandedSequenceLengths = map(
    possibleSequences,
    function (seq)
      local prev = 'A'
      local inputLength = 0

      for _, key in ipairs(seq) do
        inputLength = inputLength + arrowKeyActions(prev, key, layer - 1)
        prev = key
      end

      return inputLength
    end
  )

  local shortest = minBy(expandedSequenceLengths, function (len) return len end)

  arrowKeyMemo[memoKey] = shortest

  return shortest
end

---@param fromKey string
---@param toKey string
---@return integer
local function numericKeyActions(fromKey, toKey)
  local possibleSequences = {}
  local from = numericKeyPositions[fromKey]
  local to = numericKeyPositions[toKey]

  if from.y == 4 and to.x == 1 then
    local actions = {}
    insertVerticals(actions, from, to)
    insertHorizontals(actions, from, to)
    table.insert(actions, 'A')
    table.insert(possibleSequences, actions)
  elseif from.x == 1 and to.y == 4 then
    local actions = {}
    insertHorizontals(actions, from, to)
    insertVerticals(actions, from, to)
    table.insert(actions, 'A')
    table.insert(possibleSequences, actions)
  else
    -- try both
    local actionsHorizontalFirst = {}
    insertHorizontals(actionsHorizontalFirst, from, to)
    insertVerticals(actionsHorizontalFirst, from, to)
    table.insert(actionsHorizontalFirst, 'A')
    table.insert(possibleSequences, actionsHorizontalFirst)

    local actionsVerticalFirst = {}
    insertVerticals(actionsVerticalFirst, from, to)
    insertHorizontals(actionsVerticalFirst, from, to)
    table.insert(actionsVerticalFirst, 'A')
    table.insert(possibleSequences, actionsVerticalFirst)
  end

  local expandedSequenceLengths = map(
    possibleSequences,
    function (seq)
      local prev = 'A'
      local inputLength = 0

      for _, key in ipairs(seq) do
        inputLength = inputLength + arrowKeyActions(prev, key, 25)
        prev = key
      end

      return inputLength
    end
  )

  local shortest = minBy(expandedSequenceLengths, function (len) return len end)

  return shortest
end

local total = 0

for line in readInput() do
  local numericKeys = stringSplit(line, '')

  local prev = 'A'
  local humanInputLength = 0

  for _, key in ipairs(numericKeys) do
    humanInputLength = humanInputLength + numericKeyActions(prev, key)
    prev = key
  end

  local numericCode = tonumber(line:sub(1, -2))

  local complexity = numericCode * humanInputLength
  total = total + complexity

end

print(total)
