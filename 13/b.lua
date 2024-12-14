require('utils')
require('13/common')

---@param machine Machine
---@return Solution | nil
local function getSolution(machine)
  local am = machine.ay / machine.ax -- gradient of line A
  local bm = machine.by / machine.bx -- gradient of line B

  if am == bm then
    print('Special case! Lines have same gradient. Handle this if it comes up')
    os.exit()
  end

  -- Find point where lines intersect
  local bi = machine.py - bm * machine.px -- y-intercept of line B
  local ix = bi / (am - bm)

  -- Round to account for floating point errors
  -- Then we'll verify below if it's actually valid
  local aPresses = round(ix / machine.ax)
  local bPresses = round((machine.px - ix) / machine.bx)

  if aPresses >= 0 and bPresses >= 0 then
    -- Verify
    local finalX = aPresses * machine.ax + bPresses * machine.bx
    local finalY = aPresses * machine.ay + bPresses * machine.by
    if finalX == machine.px and finalY == machine.py then
      return { aPresses = aPresses, bPresses = bPresses }
    end
  end
end

local machines = parseInput()

for _, machine in ipairs(machines) do
  machine.px = machine.px + 10000000000000
  machine.py = machine.py + 10000000000000
end

local total = 0

for _, machine in ipairs(machines) do
  local solution = getSolution(machine)
  if solution then
    total = total + solutionCost(solution)
  end
end

print(total)
