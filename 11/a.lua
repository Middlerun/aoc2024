require('utils')
require('11/common')

local function getDescendantCount(stone, blinksRemaining)
  if blinksRemaining == 0 then return 1 end

  local total = 0
  for _, nextStone in ipairs(getNextStones(stone)) do
    total = total + getDescendantCount(nextStone, blinksRemaining - 1)
  end
  return total
end

local input = readInput()()
local initialStones = map(stringSplit(input, ' '), function(n) return tonumber(n) end)

local total = 0
for _, stone in ipairs(initialStones) do
  total = total + getDescendantCount(stone, 25)
end

print(total)
