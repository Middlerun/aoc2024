require('utils')

local total = 0

for line in readInput() do
  for x, y in line:gmatch('mul%((%d+),(%d+)%)') do
    total = total + (tonumber(x) * tonumber(y))
  end
end

print(total)
