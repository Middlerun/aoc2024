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
if isTest() then
  gridSize = 7
end

local memorySpace = generateMemorySpace(gridSize)

-- Rather than doing this one-by-one, it would be better to do a binary search.
-- But I already got the answer this way, so let's not waste time on unneeded optimisation.
for line in readInput() do
  local xy = stringSplit(line, ',')
  -- Our coordinate system is offset by 1 due to Lua's 1-indexed arrays
  local x = tonumber(xy[1]) + 1
  local y = tonumber(xy[2]) + 1
  memorySpace[y][x] = CORRUPTED

  local distance = findCheapestPath(memorySpace, gridSize)

  if distance == nil then
    print(x - 1 .. ',' .. y - 1)
    break
  end
end
