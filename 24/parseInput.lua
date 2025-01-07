---@alias GateType 'AND' | 'OR' | 'XOR'
---@alias Gate { input1: string, input2: string, output: string, type: GateType }

function parseInput()
  ---@type { [string]: boolean }
  local wireValues = {}
  ---@type { [string]: Gate }
  local logicGates = {}
  local maxZNum = 0

  local readingGates = false
  for line in readInput() do
    if line == '' then
      readingGates = true
    elseif readingGates then
      local input1, type, input2, output = line:match('([a-z0-9]+) ([A-Z]+) ([a-z0-9]+) %-> ([a-z0-9]+)')
      logicGates[output] = {
        input1 = input1,
        input2 = input2,
        output = output,
        type = type,
      }
      local num = output:match('z(%d%d)')
      if num then
        maxZNum = math.max(maxZNum, tonumber(num))
      end
    else
      local wire, value = line:match('([a-z0-9]+): ([0-1])')
      wireValues[wire] = (value == '1') and true or false
    end
  end

  return wireValues, logicGates, maxZNum
end

return parseInput
