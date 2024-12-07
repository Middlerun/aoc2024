require('utils')

---@type fun(testValue: number, nums: table): boolean
local function isEquationValid(testValue, nums)
  if #nums == 1 then
    return nums[1] == testValue
  end

  local a, b = table.unpack(nums, 1, 2)

  -- addition
  local additionNums = spliceArray(nums, 1, 2, { a + b })

  -- multiplication
  local multiplicationNums = spliceArray(nums, 1, 2, { a * b })

  -- concatenation
  local concatenationNums = spliceArray(nums, 1, 2, { tonumber(a .. b) })

  return
      isEquationValid(testValue, additionNums) or
      isEquationValid(testValue, multiplicationNums) or
      isEquationValid(testValue, concatenationNums)
end

local total = 0
for line in readInput() do
  local testValue, numsStr = table.unpack(stringSplit(line, ': '))
  testValue = tonumber(testValue)
  local nums = map(stringSplit(numsStr, ' '), function(n) return tonumber(n) end)

  if isEquationValid(testValue, nums) then
    total = total + testValue
  end
end

print(total)
