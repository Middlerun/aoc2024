require('utils')
require('22/common')

local allSellerSequences = {}

for line in readInput() do
  local secretNumber = tonumber(line)
  local sequences = {}
  local prev = secretNumber % 10
  local currentSequence = {}

  for i=1, 2000 do
    secretNumber = getNextSecretNumber(secretNumber)
    local onesDigit = secretNumber % 10
    local diff = onesDigit - prev
    table.insert(currentSequence, diff)
    if i > 4 then
      table.remove(currentSequence, 1)
      local sequenceKey = table.concat(currentSequence, ',')
      if type(sequences[sequenceKey]) ~= 'number' then
        sequences[sequenceKey] = onesDigit
      end
    end
    prev = onesDigit
  end
  table.insert(allSellerSequences, sequences)
end

local sequenceTotals = {}

for _, sellerSequences in ipairs(allSellerSequences) do
  for sequenceKey, amount in pairs(sellerSequences) do
    sequenceTotals[sequenceKey] = (sequenceTotals[sequenceKey] or 0) + amount
  end
end

local max = 0
for sequenceKey, amount in pairs(sequenceTotals) do
  if amount > max then
    max = amount
  end
end

print(max)