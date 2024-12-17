require('utils')
require('priorityQueue')

WALL = '#'
EMPTY = '.'
UP = '^'
DOWN = 'v'
LEFT = '<'
RIGHT = '>'

MOVE_COST = 1
TURN_COST = 1000

CLOCKWISE = {
  [UP] = RIGHT,
  [RIGHT] = DOWN,
  [DOWN] = LEFT,
  [LEFT] = UP,
}

ANTI_CLOCKWISE = {
  [UP] = LEFT,
  [LEFT] = DOWN,
  [DOWN] = RIGHT,
  [RIGHT] = UP,
}

DIRECTIONS = {
  [UP] = { x = 0, y = -1 },
  [DOWN] = { x = 0, y = 1 },
  [RIGHT] = { x = 1, y = 0 },
  [LEFT] = { x = -1, y = 0 },
}

---@alias GraphNode { x: number, y: number, direction: string, key: string, cameFrom: GraphNode[], gScore: number, fScore: number, partOfABestPath: boolean }

local function parseInput()
  local startX
  local startY
  local endX
  local endY

  local rows = {}
  for line in readInput() do
    local row = stringSplit(line, '')
    for x, tile in ipairs(row) do
      if tile == 'S' then
        startX = x
        startY = #rows + 1
        row[x] = '.'
      elseif tile == 'E' then
        endX = x
        endY = #rows + 1
        row[x] = '.'
      end
    end
    table.insert(rows, row)
  end

  return rows, startX, startY, endX, endY
end

local function positionKey(x, y, direction)
  return x .. ',' .. y .. direction
end

local function forward(x, y, direction)
  local forwardX = x + DIRECTIONS[direction].x
  local forwardY = y + DIRECTIONS[direction].y
  return forwardX, forwardY
end

local function markNodeAsPartOfABestPath(node)
  node.partOfABestPath = true
  for _, n in ipairs(node.cameFrom) do
    markNodeAsPartOfABestPath(n)
  end
end

local function findCheapestPath(rows, startDirection, startX, startY, endX, endY)
  local function heuristic(x, y, direction)
    local turnsNeeded = 0
    if x == endX and y == endY then
      return 0
    elseif x == endX then
      if direction == DOWN then
        turnsNeeded = 2
      elseif direction == LEFT or direction == RIGHT then
        turnsNeeded = 1
      end
    elseif y == endY then
      if direction == LEFT then
        turnsNeeded = 2
      elseif direction == UP or direction == DOWN then
        turnsNeeded = 1
      end
    else
      if direction == UP or direction == RIGHT then
        turnsNeeded = 1
      else
        turnsNeeded = 2
      end
    end

    return TURN_COST * turnsNeeded + MOVE_COST * (math.abs(endX - x) + math.abs(endY - y))
  end

  ---@type { [string]: GraphNode }
  local nodes = {}

  local function getOrCreateNode(x, y, direction)
    local key = positionKey(x, y, direction)
    if nodes[key] then return nodes[key] end
    ---@type GraphNode
    local node = {
      x = x,
      y = y,
      direction = direction,
      key = key,
      gScore = math.maxinteger,
      fScore = math.maxinteger,
      partOfABestPath = false,
      cameFrom = {},
    }
    nodes[key] = node
    return node
  end

  ---@type GraphNode
  local startNode = getOrCreateNode(startX, startY, startDirection)
  startNode.gScore = 0
  startNode.fScore = heuristic(startNode.x, startNode.y, startNode.direction)
  local openSet = PriorityQueue:new()
  openSet:add(startNode.key, startNode.fScore)
  local bestPathCost = math.maxinteger

  while not openSet:isEmpty() do
    local currentKey = openSet:pop()
    local currentNode = nodes[currentKey]

    if currentNode.fScore <= bestPathCost then
      if currentNode.x == endX and currentNode.y == endY then
        if currentNode.fScore <= bestPathCost then
          bestPathCost = currentNode.fScore
          markNodeAsPartOfABestPath(currentNode)
        end
      end

      -- get neighbours
      local neighbours = {
        { getOrCreateNode(currentNode.x, currentNode.y, ANTI_CLOCKWISE[currentNode.direction]), TURN_COST },
        { getOrCreateNode(currentNode.x, currentNode.y, CLOCKWISE[currentNode.direction]),      TURN_COST },
      }
      local forwardX, forwardY = forward(currentNode.x, currentNode.y, currentNode.direction)
      if rows[forwardY][forwardX] == '.' then
        table.insert(
          neighbours,
          { getOrCreateNode(forwardX, forwardY, currentNode.direction), MOVE_COST }
        )
      end

      for _, neighbourAndCost in ipairs(neighbours) do
        local neighbour, cost = table.unpack(neighbourAndCost)

        local tentativeGScore = currentNode.gScore + cost

        if tentativeGScore == neighbour.gScore and neighbour.partOfABestPath then
          -- found an equally good path!
          table.insert(neighbour.cameFrom, currentNode)
          markNodeAsPartOfABestPath(currentNode)
        elseif tentativeGScore == neighbour.gScore then
          -- found an equally good path!
          table.insert(neighbour.cameFrom, currentNode)
        elseif tentativeGScore < neighbour.gScore then
          -- found a better path to this node!
          neighbour.cameFrom = { currentNode }
          neighbour.gScore = tentativeGScore
          neighbour.fScore = tentativeGScore + heuristic(neighbour.x, neighbour.y, neighbour.direction)

          if openSet:has(neighbour.key) then
            openSet:updatePriority(neighbour.key, neighbour.fScore)
          else
            openSet:add(neighbour.key, neighbour.fScore)
          end
        end
      end
    end
  end

  return nodes
end

local rows, startX, startY, endX, endY = parseInput()

local nodes = findCheapestPath(rows, RIGHT, startX, startY, endX, endY)

-- printGrid(rows, function(v, x, y)
--   if (nodes[positionKey(x, y, UP)] and nodes[positionKey(x, y, UP)].partOfABestPath) or
--       (nodes[positionKey(x, y, DOWN)] and nodes[positionKey(x, y, DOWN)].partOfABestPath) or
--       (nodes[positionKey(x, y, LEFT)] and nodes[positionKey(x, y, LEFT)].partOfABestPath) or
--       (nodes[positionKey(x, y, RIGHT)] and nodes[positionKey(x, y, RIGHT)].partOfABestPath)
--   then
--     return 'O'
--   else
--     return v
--   end
-- end)

local total = 0
local spacesPartOfABestPath = {}

for _, node in pairs(nodes) do
  local spaceKey = node.x .. ',' .. node.y
  if node.partOfABestPath and not spacesPartOfABestPath[spaceKey] then
    spacesPartOfABestPath[spaceKey] = true
    total = total + 1
  end
end

print(total)
