require('read')

local similarityScore = 0

local listA = {}

-- Used to count the number of times any given number appears in list B
local listBCounts = {}
function listBCounts:get(n)
  return self[n] or 0
end

function listBCounts:increment(n)
  self[n] = self:get(n) + 1
end

for line in readInput() do
  local a, b = line:match('(%d+) +(%d+)')
  table.insert(listA, tonumber(a))
  listBCounts:increment(tonumber(b))
end

for i = 1, #listA do
  local n = listA[i]
  local count = listBCounts:get(n)
  similarityScore = similarityScore + (n * count)
end

print(similarityScore)
