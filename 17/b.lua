require('utils')
require('17/common')
local bn = require('bn')

local program = parseInput()

local function findTheMagicNumber(requiredOutputsReversed, initialValue)
  if #requiredOutputsReversed == 0 then
    return initialValue
  end

  local num = bn(requiredOutputsReversed[1])
  initialValue = initialValue * 8
  for candidate = 0, 7 do
    local registerA = initialValue + bn(candidate)
    local registerB = bn(0)
    local registerC = bn(0)

    -- BST 4: Take register A modulo 8, and put it in register B
    registerB = registerA % bn(8)

    -- BXL 5: Bitwise XOR of register B and 5 (101), put it in register B
    registerB = registerB ~ 5

    -- CDV 5: Divide register A by (2 ^ register B), and store it in register C
    registerC = registerA / bn(2 ^ registerB)

    -- BXL 6: Bitwise XOR of register B and 6 (110), put it in register B
    registerB = registerB ~ 6

    -- BXC 2: Bitwise XOR of register B and register C, put it in register B
    registerB = registerB ~ registerC

    -- OUT 5: Output result of register B % 8
    local output = registerB % 8
    if output == num then
      local magicNumber = findTheMagicNumber(
        spliceArray(requiredOutputsReversed, 1, 1, {}),
        registerA
      )
      if magicNumber then return magicNumber end
    end
  end
end

local magicNumber = findTheMagicNumber(arrayReverse(program), bn(0))

print(magicNumber)
