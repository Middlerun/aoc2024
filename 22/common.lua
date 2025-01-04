local function mix(n1, n2)
  return n1 ~ n2
end

local function prune(n)
  return n % 16777216
end

---@param n number
---@return number
function getNextSecretNumber(n)
  n = prune(mix(n, n * 64))
  n = prune(mix(n, math.floor(n / 32)))
  n = prune(mix(n, n * 2048))
  return n
end
