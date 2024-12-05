require('utils')
require('05/common')

local updates, rulesByFirstPage = parseInput()

local total = 0

for _, update in ipairs(updates) do
  if isUpdateValid(update, rulesByFirstPage) then
    local middleIndex = math.ceil(#update / 2)
    local middleNumber = update[middleIndex]
    total = total + middleNumber
  end
end

print(total)
