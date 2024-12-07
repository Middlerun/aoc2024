require('utils')

local EMPTY_VISITED = 'X'
local GUARD_UP = '^'
local OBSTACLE = '#'

local UP = 1
-- RIGHT = 2
-- DOWN = 3
-- LEFT = 4

local directionSteps = {
  { x = 0,  y = -1 },
  { x = 1,  y = 0 },
  { x = 0,  y = 1 },
  { x = -1, y = 0 },
}

local function parseInput()
  local guardX
  local guardY
  local rows = {}

  for line in readInput() do
    local row = stringSplit(line, '')
    if not guardY then
      guardX = line:find(GUARD_UP, 1, true)
      if guardX then
        guardY = #rows + 1
        row[guardX] = EMPTY_VISITED -- mark spot as visited
      end
    end
    table.insert(rows, row)
  end

  return rows, guardX, guardY
end

local function rotateClockwise(direction)
  if direction == 4 then
    return 1
  else
    return direction + 1
  end
end

---@type fun(rows: table, guardX: number, guardY: number, guardDirection: number): number, number, number, boolean
local function step(rows, guardX, guardY, guardDirection)
  local forwardX = guardX + directionSteps[guardDirection].x
  local forwardY = guardY + directionSteps[guardDirection].y

  local forwardIsWithinMap = rows[forwardY] and rows[forwardY][forwardX]

  if not forwardIsWithinMap then
    return forwardX, forwardY, guardDirection, true
  end

  local forwardTile = rows[forwardY][forwardX]

  if forwardTile == OBSTACLE then
    return guardX, guardY, rotateClockwise(guardDirection), false
  else
    rows[forwardY][forwardX] = EMPTY_VISITED
    return forwardX, forwardY, guardDirection, false
  end
end

local rows, guardX, guardY = parseInput()
local guardDirection = UP
local finished = false

while not finished do
  guardX, guardY, guardDirection, finished = step(rows, guardX, guardY, guardDirection)
end

local totalVisitedSpaces = 0

for _, row in ipairs(rows) do
  for _, tile in ipairs(row) do
    if tile == EMPTY_VISITED then
      totalVisitedSpaces = totalVisitedSpaces + 1
    end
  end
end

print(totalVisitedSpaces)
