EMPTY = '.'
CORRUPTED = '#'

UP = 1
DOWN = 2
LEFT = 3
RIGHT = 4

local DIRECTIONS = {
  [UP] = { x = 0, y = -1 },
  [DOWN] = { x = 0, y = 1 },
  [RIGHT] = { x = 1, y = 0 },
  [LEFT] = { x = -1, y = 0 },
}

---@alias GraphNode { x: number, y: number, direction: string, key: string, cameFrom: GraphNode | nil, gScore: number, fScore: number }

function positionKey(x, y)
  return x .. ',' .. y
end

function findCheapestPath(memorySpace, gridSize)
  local function heuristic(x, y)
    return (math.abs(gridSize - x) + math.abs(gridSize - y))
  end

  local nodes = {}

  local function getOrCreateNode(x, y)
    local key = positionKey(x, y)
    if nodes[key] then return nodes[key] end
    ---@type GraphNode
    local node = {
      x = x,
      y = y,
      key = key,
      gScore = math.maxinteger,
      fScore = math.maxinteger,
    }
    nodes[key] = node
    return node
  end

  ---@type GraphNode
  local startNode = getOrCreateNode(1, 1)
  startNode.gScore = 0
  startNode.fScore = heuristic(startNode.x, startNode.y)
  local openSet = PriorityQueue:new()
  openSet:add(startNode.key, startNode.fScore)

  while not openSet:isEmpty() do
    local currentKey = openSet:pop()
    local currentNode = nodes[currentKey]

    if currentNode.x == gridSize and currentNode.y == gridSize then
      local pathNodes = {}
      local traceNode = currentNode
      while traceNode do
        pathNodes[positionKey(traceNode.x, traceNode.y)] = true
        traceNode = traceNode.cameFrom
      end
      return currentNode.fScore, pathNodes
    end

    local neighbours = {}
    for _, direction in ipairs(DIRECTIONS) do
      local nx = currentNode.x + direction.x
      local ny = currentNode.y + direction.y
      if memorySpace[ny] and memorySpace[ny][nx] == EMPTY then
        table.insert(neighbours, getOrCreateNode(nx, ny))
      end
    end

    for _, neighbour in ipairs(neighbours) do
      local tentativeGScore = currentNode.gScore + 1

      if tentativeGScore < neighbour.gScore then
        -- found a better path to this node!
        neighbour.cameFrom = currentNode
        neighbour.gScore = tentativeGScore
        neighbour.fScore = tentativeGScore + heuristic(neighbour.x, neighbour.y)

        if openSet:has(neighbour.key) then
          openSet:updatePriority(neighbour.key, neighbour.fScore)
        else
          openSet:add(neighbour.key, neighbour.fScore)
        end
      end
    end
  end
end
