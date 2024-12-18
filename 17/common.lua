function parseInput()
  local getLine = readInput()

  local registerA = tonumber(getLine():match('Register A: (%d+)'))
  local registerB = tonumber(getLine():match('Register B: (%d+)'))
  local registerC = tonumber(getLine():match('Register C: (%d+)'))
  getLine()
  local rawProgram = getLine():match('Program: (.+)')
  local program = map(stringSplit(rawProgram, ','), toNumberBase10)
  return program, registerA, registerB, registerC
end
