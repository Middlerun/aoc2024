require('utils')
require('05/common')

local updates, rulesByFirstPage = parseInput()

local total = 0

for _, update in ipairs(updates) do
  if not isUpdateValid(update, rulesByFirstPage) then
    -- sort to correct order
    table.sort(update, function(a, b)
      local rules = rulesByFirstPage[a] or {}
      for _, rule in ipairs(rules) do
        if rule[2] == b then return true end
      end
      return false
    end)

    local middleIndex = math.ceil(#update / 2)
    local middleNumber = update[middleIndex]
    total = total + middleNumber
  end
end

print(total)
