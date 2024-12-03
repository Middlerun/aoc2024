require('utils')

local memory = ''
local instructions = {}
local doMul = true
local total = 0

for line in readInput() do
  memory = memory .. line
end

for startPos, x, y in memory:gmatch('()mul%((%d+),(%d+)%)') do
  table.insert(instructions, {
    name = 'mul',
    startPos = startPos,
    x = tonumber(x),
    y = tonumber(y),
  })
end

for startPos in memory:gmatch('()do%(%)') do
  table.insert(instructions, {
    name = 'do',
    startPos = startPos,
  })
end

for startPos in memory:gmatch('()don\'t%(%)') do
  table.insert(instructions, {
    name = 'don\'t',
    startPos = startPos,
  })
end

table.sort(instructions, function(a, b)
  return a.startPos < b.startPos
end)

for i = 1, #instructions do
  local instruction = instructions[i]

  if instruction.name == 'do' then
    doMul = true
  elseif instruction.name == 'don\'t' then
    doMul = false
  elseif instruction.name == 'mul' and doMul then
    total = total + (instruction.x * instruction.y)
  end
end

print(total)
