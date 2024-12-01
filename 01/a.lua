require('read')

local distance = 0

local listA = {}
local listB = {}

for line in readInput() do
  local a, b = line:match('(%d+) +(%d+)')
  table.insert(listA, tonumber(a))
  table.insert(listB, tonumber(b))
end

table.sort(listA)
table.sort(listB)

for i = 1, #listA do
  local diff = math.abs(listA[i] - listB[i])
  distance = distance + diff
end

print(distance)
