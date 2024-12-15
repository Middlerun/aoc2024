require('utils')
require('14/common')

local quadrantCounts = { 0, 0, 0, 0 }
local finalPositions = {}

for line in readInput() do
  local px, py, vx, vy = line:match('p=(%d+),(%d+) v=(%-?%d+),(%-?%d+)')
  px = tonumber(px)
  py = tonumber(py)
  vx = tonumber(vx)
  vy = tonumber(vy)

  local pxFinal = (px + (vx * 100)) % ROOM_WIDTH
  local pyFinal = (py + (vy * 100)) % ROOM_HEIGHT

  local positionKey = pxFinal .. ',' .. pyFinal
  finalPositions[positionKey] = (finalPositions[positionKey] or 0) + 1

  local quadrant = coordsToQuadrant(pxFinal, pyFinal)
  if quadrant then
    quadrantCounts[quadrant] = quadrantCounts[quadrant] + 1
  end
end

-- displayPositions(finalPositions)

local safetyFactor = quadrantCounts[1] * quadrantCounts[2] * quadrantCounts[3] * quadrantCounts[4]

print(safetyFactor)
