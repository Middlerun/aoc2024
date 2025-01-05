require('utils')

---@type { [string]: { connectedComputerNames: string[], isConnected: { [string]: boolean } } }
local connectionsByComputer = {}

local function addConnection(a, b)
  if not connectionsByComputer[a] then
    connectionsByComputer[a] = {
      connectedComputerNames = {},
      isConnected = {},
    }
    setDefault(connectionsByComputer[a].isConnected, false)
  end
  table.insert(connectionsByComputer[a].connectedComputerNames, b)
  connectionsByComputer[a].isConnected[b] = true
end

for line in readInput() do
  local a, b = table.unpack(stringSplit(line, '-'))
  addConnection(a, b)
  addConnection(b, a)
end

return connectionsByComputer
