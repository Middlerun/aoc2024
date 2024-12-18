require('utils')
require('17/common')

local ADV = 0
local BXL = 1
local BST = 2
local JNZ = 3
local BXC = 4
local OUT = 5
local BDV = 6
local CDV = 7

local function resolveComboOperand(operand, registerA, registerB, registerC)
  if operand <= 3 then
    return operand
  elseif operand == 4 then
    return registerA
  elseif operand == 5 then
    return registerB
  elseif operand == 6 then
    return registerC
  else
    error('Invalid combo operand ' .. operand)
  end
end

local function evaluateInstruction(opcode, operand, registerA, registerB, registerC, pointer, output)
  local jumped = false

  if opcode == ADV then
    -- division to register A
    local numerator = registerA
    local denominator = 2 ^ resolveComboOperand(operand, registerA, registerB, registerC)
    registerA = math.modf(numerator / denominator)
  elseif opcode == BXL then
    -- bitwise XOR
    registerB = registerB ~ operand
  elseif opcode == BST then
    -- modulo 8
    registerB = resolveComboOperand(operand, registerA, registerB, registerC) % 8
  elseif opcode == JNZ then
    -- jump
    if registerA ~= 0 then
      pointer = operand
      jumped = true
    end
  elseif opcode == BXC then
    -- bitwise XOR
    registerB = registerB ~ registerC
  elseif opcode == OUT then
    -- output
    local value = resolveComboOperand(operand, registerA, registerB, registerC) % 8
    table.insert(output, value)
  elseif opcode == BDV then
    -- division to register B
    local numerator = registerA
    local denominator = 2 ^ resolveComboOperand(operand, registerA, registerB, registerC)
    registerB = math.modf(numerator / denominator)
  elseif opcode == CDV then
    -- division to register C
    local numerator = registerA
    local denominator = 2 ^ resolveComboOperand(operand, registerA, registerB, registerC)
    registerC = math.modf(numerator / denominator)
  end

  if not jumped then
    pointer = pointer + 2
  end

  return registerA, registerB, registerC, pointer
end

local function runProgram(registerA, registerB, registerC, program)
  local output = {}
  local pointer = 0

  local function getProgramValue(p)
    return program[p + 1] -- +1 to account for Lua arrays being 1-indexed, while the pointer is 0-indexed
  end

  while pointer < #program do
    local opcode = getProgramValue(pointer)
    local operand = getProgramValue(pointer + 1)

    registerA, registerB, registerC, pointer =
        evaluateInstruction(opcode, operand, registerA, registerB, registerC, pointer, output)
  end

  return output
end

local program, registerA, registerB, registerC = parseInput()

local output = runProgram(registerA, registerB, registerC, program)

print(table.concat(output, ','))
