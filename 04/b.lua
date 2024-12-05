require('utils')
require('04/common')

local rows = readGridInput()

local targetWord = { 'M', 'A', 'S' }

local orientations = {
  {
    directions = {
      -- up/right
      { x = 1,  y = -1 },
      -- down/left
      { x = -1, y = 1 },
    },
    targetCentres = {},
  },
  {
    directions = {
      -- up/left
      { x = -1, y = -1 },
      -- down/right
      { x = 1,  y = 1 },
    },
    targetCentres = {},
  },
}

for y0 = 1, #rows do
  local row = rows[y0]
  for x0 = 1, #row do
    for _, orientation in ipairs(orientations) do
      for _, direction in ipairs(orientation.directions) do
        if hasMatch(rows, x0, y0, direction, targetWord) then
          local matchCentre = {
            x = x0 + direction.x,
            y = y0 + direction.y,
          }
          orientation.targetCentres[matchCentre.x .. ',' .. matchCentre.y] = matchCentre
        end
      end
    end
  end
end

local xMasCount = 0

for k in pairs(orientations[1].targetCentres) do
  if orientations[2].targetCentres[k] then
    xMasCount = xMasCount + 1
  end
end

print(xMasCount)
