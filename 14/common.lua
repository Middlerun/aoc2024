local isTest = arg[1] == 'test' or arg[1] == 't'
ROOM_WIDTH = 101
ROOM_HEIGHT = 103
if isTest then
  ROOM_WIDTH = 11
  ROOM_HEIGHT = 7
end

MIDDLE_ROW = math.floor(ROOM_HEIGHT / 2)
MIDDLE_COL = math.floor(ROOM_WIDTH / 2)

function coordsToQuadrant(x, y)
  if x > MIDDLE_COL then
    if y < MIDDLE_ROW then
      return 1 -- upper-right quadrant
    elseif y > MIDDLE_ROW then
      return 2 -- lower-right quadrant
    end
  elseif x < MIDDLE_COL then
    if y > MIDDLE_ROW then
      return 3 -- lower-left quadrant
    elseif y < MIDDLE_ROW then
      return 4 -- upper-left quadrant
    end
  end
end

function displayPositions(positions)
  local str = ''
  for y = 0, ROOM_HEIGHT - 1 do
    local row = ''
    for x = 0, ROOM_WIDTH - 1 do
      local count = positions[x .. ',' .. y]
      if count then
        row = row .. count
      else
        row = row .. '.'
      end
    end
    str = str .. row .. '\n'
  end
  print(str)
end
