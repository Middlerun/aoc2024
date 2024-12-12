require('utils')
require('11/common')

local descendantCountMemo = {}

local function getDescendantCount(stone, blinksRemaining)
  if blinksRemaining == 0 then return 1 end

  local memoKey = stone .. ',' .. blinksRemaining
  local memoValue = descendantCountMemo[memoKey]

  if memoValue ~= nil then return memoValue end

  local total = 0
  for _, nextStone in ipairs(getNextStones(stone)) do
    total = total + getDescendantCount(nextStone, blinksRemaining - 1)
  end

  descendantCountMemo[memoKey] = total

  return total
end

local input = readInput()()
local initialStones = map(stringSplit(input, ' '), function(n) return tonumber(n) end)

local total = 0
for _, stone in ipairs(initialStones) do
  total = total + getDescendantCount(stone, 75)
end

print(total)
