require('utils')

local connectionsByComputer = require('23/common')

local function areComputersConnected(a, b)
  return connectionsByComputer[a].isConnected[b]
end

---@param setSoFar string[]
---@param largestSoFar string[]
---@return string[]
local function findLargestSet(setSoFar, largestSoFar)
  if #setSoFar > #largestSoFar then
    largestSoFar = setSoFar
  end
  local latest = setSoFar[#setSoFar]
  local possibleConnections = connectionsByComputer[latest].connectedComputerNames
  for _, nextComputer in ipairs(possibleConnections) do
    if
      -- As in part 1, only consider the names when they're in order
      nextComputer > latest and
      every(setSoFar, function(name) return areComputersConnected(name, nextComputer) end)
    then
      local newSet = deepClone(setSoFar)
      table.insert(newSet, nextComputer)
      largestSoFar = findLargestSet(newSet, largestSoFar)
    end
  end
  return largestSoFar
end

local largestSet = {}

for a, _ in pairs(connectionsByComputer) do
  largestSet = findLargestSet({ a }, largestSet)
end

print(table.concat(largestSet, ','))