require('utils')

local similarityScore = 0

local listA = {}

-- Used to count the number of times any given number appears in list B
local listBCounts = {}
setDefault(listBCounts, 0)

function listBCounts:increment(n)
  self[n] = self[n] + 1
end

for line in readInput() do
  local a, b = line:match('(%d+) +(%d+)')
  table.insert(listA, tonumber(a))
  listBCounts:increment(tonumber(b))
end

for i = 1, #listA do
  local n = listA[i]
  local count = listBCounts[n]
  similarityScore = similarityScore + (n * count)
end

print(similarityScore)
