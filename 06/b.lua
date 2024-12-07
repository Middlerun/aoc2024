require('utils')

local VISITED_UP = '^'
local OBSTACLE = '#'

local TILE_TYPE_EMPTY = 'empty'
local TILE_TYPE_OBSTACLE = 'obstacle'

local UP = 1
local RIGHT = 2
local DOWN = 3
local LEFT = 4

local directionSteps = {
  { x = 0,  y = -1 },
  { x = 1,  y = 0 },
  { x = 0,  y = 1 },
  { x = -1, y = 0 },
}

local function tileToChar(tile)
  if tile.type == TILE_TYPE_OBSTACLE then
    if tile.hypothetical then
      return 'O'
    else
      return OBSTACLE
    end
  end

  if tile.visited[UP] or tile.visited[DOWN] then
    if tile.visited[LEFT] or tile.visited[RIGHT] then
      return '+'
    else
      return '|'
    end
  else
    if tile.visited[LEFT] or tile.visited[RIGHT] then
      return '-'
    else
      return '.'
    end
  end
end

local function printMap(rows)
  printGrid(map(rows, function(row)
    return map(row, tileToChar)
  end))
end

local function parseInput()
  local guardX
  local guardY
  local rows = {}

  for line in readInput() do
    local row = {}

    for x, tileStr in ipairs(stringSplit(line, '')) do
      if tileStr == VISITED_UP then
        guardX = x
        guardY = #rows + 1
        table.insert(row, { type = TILE_TYPE_EMPTY, visited = { true, false, false, false } })
      elseif tileStr == OBSTACLE then
        table.insert(row, { type = TILE_TYPE_OBSTACLE })
      else
        table.insert(row, { type = TILE_TYPE_EMPTY, visited = { false, false, false, false } })
      end
    end

    if not guardY then
      guardX = line:find(VISITED_UP, 1, true)
      if guardX then
        guardY = #rows + 1
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

---@type fun(rows: table, startX: number, startY: number, startDirection: number, obstacleX: number, obstacleY: number): boolean
local function testForLoop(originalRows, startX, startY, startDirection, obstacleX, obstacleY)
  local rows = deepClone(originalRows)
  rows[obstacleY][obstacleX] = { type = TILE_TYPE_OBSTACLE, hypothetical = true }
  local x = startX
  local y = startY
  local direction = startDirection
  while true do
    local currentTile = rows[y][x]
    if currentTile.visited[direction] then
      return true
    end

    currentTile.visited[direction] = true

    local forwardX = x + directionSteps[direction].x
    local forwardY = y + directionSteps[direction].y
    local forwardIsWithinMap = rows[forwardY] and rows[forwardY][forwardX]

    if not forwardIsWithinMap then
      return false
    end

    local forwardTile = rows[forwardY][forwardX]

    if forwardTile.type == TILE_TYPE_OBSTACLE then
      direction = rotateClockwise(direction)
    else
      x = forwardX
      y = forwardY
    end
  end
end

local obstacleCandidateCount = 0

---@type fun(rows: table, guardX: number, guardY: number, guardDirection: number): number, number, number, boolean
local function step(rows, guardX, guardY, guardDirection)
  local forwardX = guardX + directionSteps[guardDirection].x
  local forwardY = guardY + directionSteps[guardDirection].y

  local forwardIsWithinMap = rows[forwardY] and rows[forwardY][forwardX]

  if not forwardIsWithinMap then
    return forwardX, forwardY, guardDirection, true
  end

  local forwardTile = rows[forwardY][forwardX]

  if forwardTile.type == TILE_TYPE_OBSTACLE then
    local newDirection = rotateClockwise(guardDirection)
    rows[guardY][guardX].visited[newDirection] = true
    return guardX, guardY, newDirection, false
  else
    -- test whether this forward space would cause a loop if it contained an obstacle
    if
        not forwardTile.isValidObstacleCandidate and
        not forwardTile.visited[UP] and
        not forwardTile.visited[RIGHT] and
        not forwardTile.visited[DOWN] and
        not forwardTile.visited[LEFT] and
        testForLoop(rows, guardX, guardY, rotateClockwise(guardDirection), forwardX, forwardY)
    then
      obstacleCandidateCount = obstacleCandidateCount + 1
      forwardTile.isValidObstacleCandidate = true
    end

    forwardTile.visited[guardDirection] = true
    return forwardX, forwardY, guardDirection, false
  end
end

local rows, guardX, guardY = parseInput()
local guardDirection = UP
local finished = false

-- this takes a while - O(n^2) complexity
while not finished do
  guardX, guardY, guardDirection, finished = step(rows, guardX, guardY, guardDirection)
end

print(obstacleCandidateCount)
