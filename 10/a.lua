require('utils')

function findReachableNines(rows, x, y, value, reachableNines)
  if rows[y] == nil or rows[y][x] ~= value then
    return
  end
  if value == 9 then
    reachableNines[x .. ',' .. y] = { x = x, y = y }
    return
  end

  findReachableNines(rows, x, y - 1, value + 1, reachableNines)
  findReachableNines(rows, x - 1, y, value + 1, reachableNines)
  findReachableNines(rows, x, y + 1, value + 1, reachableNines)
  findReachableNines(rows, x + 1, y, value + 1, reachableNines)
end

local rows = readGridInput(function(n) return tonumber(n) end)

local total = 0

for y0 = 1, #rows do
  local row = rows[y0]
  for x0 = 1, #row do
    local reachableNines = {}
    findReachableNines(rows, x0, y0, 0, reachableNines)
    for _, _ in pairs(reachableNines) do
      total = total + 1
    end
  end
end

print(total)
