require('utils')
require('08/common')

local antennasByFrequency, nodeInMap = parseInput()

local antinodeLocations = {}

-- reduce to the smallest integer steps
function reduceInterval(dx, dy)
  for div = math.floor(dx / 2), 2, -1 do
    local tdx = dx / div
    local tdy = dy / div
    local _, fx = math.modf(tdx)
    local _, fy = math.modf(tdy)
    if (fx == 0 and fy == 0) then
      return tdx, tdy
    end
  end
  return dx, dy
end

for _, locations in pairs(antennasByFrequency) do
  for i = 2, #locations do
    for j = 1, i - 1 do
      local location1 = locations[i]
      local location2 = locations[j]

      local dx = location2.x - location1.x
      local dy = location2.y - location1.y
      dx, dy = reduceInterval(dx, dy)

      -- get all antinodes in both directions
      local k = 0
      while true do
        local antinode = { x = location1.x + k * dx, y = location1.y + k * dy }
        if nodeInMap(antinode) then
          antinodeLocations[nodeToString(antinode)] = true
        else
          break
        end
        k = k - 1
      end
      k = 1
      while true do
        local antinode = { x = location1.x + k * dx, y = location1.y + k * dy }
        if nodeInMap(antinode) then
          antinodeLocations[nodeToString(antinode)] = true
        else
          break
        end
        k = k + 1
      end
    end
  end
end

local total = 0
for _, _ in pairs(antinodeLocations) do total = total + 1 end

print(total)
