---@alias Machine { ax: number, ay: number, bx: number, by: number, px: number, py: number }
---@alias Solution { aPresses: number, bPresses: number }

A_BUTTON_COST = 3
B_BUTTON_COST = 1

---@return Machine[]
function parseInput()
  local inputIterator = readInput()
  ---@type Machine[]
  local machines = {}

  while true do
    local line1 = inputIterator()
    local line2 = inputIterator()
    local line3 = inputIterator()

    local _, _, ax, ay = line1:find('X%+(%d+), Y%+(%d+)')
    local _, _, bx, by = line2:find('X%+(%d+), Y%+(%d+)')
    local _, _, px, py = line3:find('X=(%d+), Y=(%d+)')

    table.insert(machines, {
      ax = tonumber(ax),
      ay = tonumber(ay),
      bx = tonumber(bx),
      by = tonumber(by),
      px = tonumber(px),
      py = tonumber(py),
    })

    if inputIterator() == nil then
      break
    end
  end

  return machines
end

---@param solution Solution
---@return number
function solutionCost(solution)
  return solution.aPresses * A_BUTTON_COST + solution.bPresses * B_BUTTON_COST
end
