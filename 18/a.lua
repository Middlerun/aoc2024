require('utils')
require('18/common')
require('priorityQueue')

local function generateMemorySpace(gridMax)
  local rows = {}
  for y = 1, gridMax do
    local row = {}
    for x = 1, gridMax do
      row[x] = EMPTY
    end
    rows[y] = row
  end
  return rows
end

local gridSize = 71
local bytesToSimulate = 1024
if isTest() then
  gridSize = 7
  bytesToSimulate = 12
end

local memorySpace = generateMemorySpace(gridSize)

local getLine = readInput()
for _ = 1, bytesToSimulate do
  local xy = stringSplit(getLine(), ',')
  -- Our coordinate system is offset by 1 due to Lua's 1-indexed arrays
  local x = tonumber(xy[1]) + 1
  local y = tonumber(xy[2]) + 1
  memorySpace[y][x] = CORRUPTED
end

local distance, pathNodes = findCheapestPath(memorySpace, gridSize)

-- printGrid(memorySpace, function(v, x, y)
--   if pathNodes[x .. ',' .. y] then return 'O' end
--   return v
-- end)

print(distance)
