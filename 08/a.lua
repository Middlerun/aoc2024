require('utils')
require('08/common')

local antennasByFrequency, nodeInMap = parseInput()

local antinodeLocations = {}

for _, locations in pairs(antennasByFrequency) do
  for i = 2, #locations do
    for j = 1, i - 1 do
      local location1 = locations[i]
      local location2 = locations[j]

      local dx = location2.x - location1.x
      local dy = location2.y - location1.y

      local antinode1 = { x = location1.x - dx, y = location1.y - dy }
      local antinode2 = { x = location2.x + dx, y = location2.y + dy }

      if nodeInMap(antinode1) then antinodeLocations[nodeToString(antinode1)] = true end
      if nodeInMap(antinode2) then antinodeLocations[nodeToString(antinode2)] = true end
    end
  end
end

local total = 0
for _, _ in pairs(antinodeLocations) do total = total + 1 end

print(total)
