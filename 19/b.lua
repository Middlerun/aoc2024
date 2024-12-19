require('utils')

local getLine = readInput()

local towels = stringSplit(getLine(), ', ')
local designs = {}

getLine()
for line in getLine do
  table.insert(designs, line)
end

local memo = {}

---@param design string
local function totalWaysToMakeDesign(design)
  if design == '' then
    return 1
  elseif memo[design] then
    return memo[design]
  end

  local ways = 0

  for _, towel in ipairs(towels) do
    local towelStripes = towel:len()
    if design:sub(1, towelStripes) == towel then
      ways = ways + totalWaysToMakeDesign(design:sub(towelStripes + 1))
    end
  end

  memo[design] = ways

  return ways
end

local totalWaysToMakeDesigns = 0

for _, design in ipairs(designs) do
  totalWaysToMakeDesigns = totalWaysToMakeDesigns + totalWaysToMakeDesign(design)
end

print(totalWaysToMakeDesigns)
