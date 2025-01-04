require('utils')
require('22/common')

local total = 0

for line in readInput() do
  local secretNumber = tonumber(line)

  for _=1, 2000 do
    secretNumber = getNextSecretNumber(secretNumber)
  end
  total = total + secretNumber
end

print(total)