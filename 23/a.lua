require('utils')

local connectionsByComputer = require('23/common')

local function areComputersConnected(a, b)
  return connectionsByComputer[a].isConnected[b]
end

local total = 0

for a, aConnections in pairs(connectionsByComputer) do
  for _, b in ipairs(aConnections.connectedComputerNames) do
    -- we'll encounter the group a,b,c in every possible permutation, so to avoid counting
    -- the set multiple times, only consider them when they're in ASCII order.
    if a < b then
      for _, c in ipairs(aConnections.connectedComputerNames) do
        if b < c and areComputersConnected(b, c) then
          if a:sub(1, 1) == 't' or b:sub(1, 1) == 't' or c:sub(1, 1) == 't' then
            total = total + 1
          end
        end
      end
    end
  end
end

print(total)