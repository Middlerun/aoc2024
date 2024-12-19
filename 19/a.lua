require('utils')

local getLine = readInput()

local towels = stringSplit(getLine(), ', ')
local designs = {}

getLine()
for line in getLine do
  table.insert(designs, line)
end

---@param design string
local function canMakeDesign(design)
  if design == '' then return true end

  for _, towel in ipairs(towels) do
    local towelStripes = towel:len()
    if design:sub(1, towelStripes) == towel and canMakeDesign(design:sub(towelStripes + 1)) then
      return true
    end
  end
  return false
end

local possibleDesignCount = 0

for _, design in ipairs(designs) do
  if canMakeDesign(design) then
    possibleDesignCount = possibleDesignCount + 1
  end
end

print(possibleDesignCount)
