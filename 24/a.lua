require('utils')
local parseInput = require('24/parseInput')

local wireValues, logicGates, maxZNum = parseInput()

local function getWireValue(wire)
  if type(wireValues[wire]) == 'boolean' then
    return wireValues[wire]
  end

  local gate = logicGates[wire]

  if not gate then
    error('No value or gate for wire ' .. wire)
  end

  local value
  if gate.type == 'AND' then
    value = getWireValue(gate.input1) and getWireValue(gate.input2)
  elseif gate.type == 'OR' then
    value = getWireValue(gate.input1) or getWireValue(gate.input2)
  else
    value = xor(getWireValue(gate.input1), getWireValue(gate.input2))
  end

  wireValues[wire] = value
  return value
end

local total = 0

local column = 1
for i = 0, maxZNum do
  local wire = 'z' .. zeroPad(i, 2)
  if getWireValue(wire) then
    total = total + column
  end
  column = column * 2
end

print(total)