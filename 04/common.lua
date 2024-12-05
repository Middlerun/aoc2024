require('utils')

function readGridInput()
  local defaultRow = {}
  setDefault(defaultRow, '.')

  local rows = {}
  setDefault(rows, defaultRow)

  for line in readInput() do
    local row = {}
    setDefault(row, '.')
    for i = 1, line:len() do
      table.insert(row, string.sub(line, i, i))
    end
    table.insert(rows, row)
  end

  return rows
end

function hasMatch(rows, x0, y0, direction, targetWord)
  local match = true
  for i, targetLetter in ipairs(targetWord) do
    local x = x0 + (i - 1) * direction.x
    local y = y0 + (i - 1) * direction.y
    local letter = rows[y][x]
    if (letter ~= targetLetter) then
      match = false
      break
    end
  end
  return match
end
