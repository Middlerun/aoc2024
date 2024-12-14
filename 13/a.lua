require('utils')
require('13/common')

---@param machine Machine
---@return Solution[]
local function getSolutions(machine)
  ---@type Solution[]
  local solutions = {}
  for aPresses = 0, 100 do
    local remainingX = machine.px - (machine.ax * aPresses)
    if remainingX >= 0 then
      local bPresses = remainingX / machine.bx
      local fractionalPart
      bPresses, fractionalPart = math.modf(bPresses)
      if fractionalPart == 0 then
        -- Check if this number of A and B presses would get us to the right Y coordinate
        if machine.ay * aPresses + machine.by * bPresses == machine.py then
          table.insert(solutions, { aPresses = aPresses, bPresses = bPresses })
        end
      end
    else
      break
    end
  end
  return solutions
end

local machines = parseInput()

local total = 0

for _, machine in ipairs(machines) do
  local solutions = getSolutions(machine)
  if #solutions > 0 then
    local _, lowestCost = minBy(solutions, solutionCost)
    total = total + lowestCost
  end
end

print(total)
