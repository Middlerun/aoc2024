require('utils')
require('04/common')

local rows = readGridInput()

local targetWord = { 'X', 'M', 'A', 'S' }

local directions = {
  -- right
  { x = 1,  y = 0 },
  -- up/right
  { x = 1,  y = -1 },
  -- up
  { x = 0,  y = -1 },
  -- up/left
  { x = -1, y = -1 },
  -- left
  { x = -1, y = 0 },
  -- down/left
  { x = -1, y = 1 },
  -- down
  { x = 0,  y = 1 },
  -- down/right
  { x = 1,  y = 1 },
}

local xmasCount = 0

for y0 = 1, #rows do
  local row = rows[y0]
  for x0 = 1, #row do
    for _, direction in ipairs(directions) do
      if hasMatch(rows, x0, y0, direction, targetWord) then
        xmasCount = xmasCount + 1
      end
    end
  end
end

print(xmasCount)
