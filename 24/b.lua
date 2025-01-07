require('utils')
local parseInput = require('24/parseInput')

local _, logicGates, maxZNum = parseInput()

local function getWireValue(wire, wireValues)
  if type(wireValues[wire]) == 'boolean' then
    return wireValues[wire]
  end

  local gate = logicGates[wire]

  if not gate then
    error('No value or gate for wire ' .. wire)
  end

  local value
  if gate.type == 'AND' then
    value = getWireValue(gate.input1, wireValues) and getWireValue(gate.input2, wireValues)
  elseif gate.type == 'OR' then
    value = getWireValue(gate.input1, wireValues) or getWireValue(gate.input2, wireValues)
  else
    value = xor(getWireValue(gate.input1, wireValues), getWireValue(gate.input2, wireValues))
  end

  wireValues[wire] = value
  return value
end

  ---@return { [string]: boolean }
local function getZeroedWires()
  local wireValues = {}
  for i = 0, maxZNum do
    local xWire = 'x' .. zeroPad(i, 2)
    local yWire = 'y' .. zeroPad(i, 2)
    wireValues[xWire] = false
    wireValues[yWire] = false
  end
  return wireValues
end

local investigationMode = false

if investigationMode then
  for i = 0, maxZNum-1 do
    local xWire = 'x' .. zeroPad(i, 2)
    local yWire = 'y' .. zeroPad(i, 2)
    local zWire = 'z' .. zeroPad(i, 2)

    ---@type { [string]: boolean }
    local wireValues

    -- test: column adds to zero, with no carry in or out
    wireValues = getZeroedWires()
    if getWireValue(zWire, wireValues) ~= false then
      print('Incorrect output for ' .. zWire .. ' when columns add to 0 with no carry in')
    end

    -- test: column adds to one, with no carry in or out
    wireValues = getZeroedWires()
    wireValues[xWire] = true
    if getWireValue(zWire, wireValues) ~= true then
      print('Incorrect output for ' .. zWire .. ' when columns add to 1 with no carry in')
    end

    -- test: column adds to two, with no carry in or out
    wireValues = getZeroedWires()
    wireValues[xWire] = true
    wireValues[yWire] = true
    if getWireValue(zWire, wireValues) ~= false then
      print('Incorrect output for ' .. zWire .. ' when columns add to 2 with no carry in')
    end

    if i > 0 then
      local prevXWire = 'x' .. zeroPad(i-1, 2)
      local prevYWire = 'y' .. zeroPad(i-1, 2)

      -- test: column adds to zero, with carry in
      wireValues = getZeroedWires()
      wireValues[prevXWire] = true
      wireValues[prevYWire] = true
      if getWireValue(zWire, wireValues) ~= true then
        print('Incorrect output for ' .. zWire .. ' when columns add to 0 with carry in')
      end

      -- test: column adds to one, with carry in
      wireValues = getZeroedWires()
      wireValues[prevXWire] = true
      wireValues[prevYWire] = true
      wireValues[xWire] = true
      if getWireValue(zWire, wireValues) ~= false then
        print('Incorrect output for ' .. zWire .. ' when columns add to 1 with carry in')
      end

      -- test: column adds to one, with carry in
      wireValues = getZeroedWires()
      wireValues[prevXWire] = true
      wireValues[prevYWire] = true
      wireValues[xWire] = true
      wireValues[yWire] = true
      if getWireValue(zWire, wireValues) ~= true then
        print('Incorrect output for ' .. zWire .. ' when columns add to 2 with carry in')
      end
    end
  end
end

-- I didn't determine the answer fully via code. Instead I used the above tests to figure out
-- which columns didn't add properly, then I manually inspected the gates for that column to
-- figure out which were swapped. This was the result:
print('fgt,fpq,nqk,pcp,srn,z07,z24,z32')
