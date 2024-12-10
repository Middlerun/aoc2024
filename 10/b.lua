require('utils')

function findDistinctTrails(rows, x, y, value)
  if rows[y] == nil or rows[y][x] ~= value then
    return 0
  end
  if value == 9 then
    return 1
  end

  return
      findDistinctTrails(rows, x, y - 1, value + 1) +
      findDistinctTrails(rows, x - 1, y, value + 1) +
      findDistinctTrails(rows, x, y + 1, value + 1) +
      findDistinctTrails(rows, x + 1, y, value + 1)
end

local rows = readGridInput(function(n) return tonumber(n) end)

local total = 0

for y0 = 1, #rows do
  local row = rows[y0]
  for x0 = 1, #row do
    local rating = findDistinctTrails(rows, x0, y0, 0)
    total = total + rating
  end
end

print(total)
