require('utils')

WALL = '#'
BOX = 'O'
ROBOT = '@'
EMPTY = '.'
UP = '^'
DOWN = 'v'
LEFT = '<'
RIGHT = '>'

DIRECTIONS = {
  [UP] = { x = 0, y = -1 },
  [DOWN] = { x = 0, y = 1 },
  [RIGHT] = { x = 1, y = 0 },
  [LEFT] = { x = -1, y = 0 },
}

local function parseInput()
  local roomRows = {}
  local instructions = {}
  local isReadingRoom = true
  local robotX
  local robotY
  for line in readInput() do
    if line == '' then
      isReadingRoom = false
    elseif isReadingRoom then
      local row = stringSplit(line, '')
      local robotRowX = line:find('@')
      if robotRowX then
        robotX = robotRowX
        robotY = #roomRows + 1
        row[robotX] = EMPTY
      end
      table.insert(roomRows, row)
    else
      for i = 1, line:len() do
        table.insert(instructions, line:sub(i, i))
      end
    end
  end

  return roomRows, robotX, robotY, instructions
end

local function printRoomGrid(roomRows, robotX, robotY)
  printGrid(roomRows, function(char, x, y)
    if x == robotX and y == robotY then return ROBOT end
    return char
  end)
end

local function push(roomRows, pusherType, pusherX, pusherY, direction)
  local pushedX = pusherX + DIRECTIONS[direction].x
  local pushedY = pusherY + DIRECTIONS[direction].y
  local pushed = roomRows[pushedY][pushedX]

  if pushed == WALL then
    return false, pusherX, pusherY
  elseif pushed == EMPTY then
    if pusherType ~= ROBOT then
      roomRows[pushedY][pushedX] = pusherType
      roomRows[pusherY][pusherX] = EMPTY
    end
    return true, pushedX, pushedY
  elseif pushed == BOX then
    local didPush = push(roomRows, BOX, pushedX, pushedY, direction)
    if didPush then
      if pusherType ~= ROBOT then
        roomRows[pushedY][pushedX] = pusherType
        roomRows[pusherY][pusherX] = EMPTY
      end
      return true, pushedX, pushedY
    else
      return false, pusherX, pusherY
    end
  else
    print('Unhandled case!')
    os.exit()
  end
end

local function getCoordinateValue(x, y)
  -- Coords here are 1-indexed, but the calculation requires 0-indexed values
  return (y - 1) * 100 + x - 1
end

local roomRows, robotX, robotY, instructions = parseInput()

-- printRoomGrid(roomRows, robotX, robotY)

for _, direction in ipairs(instructions) do
  -- print('')
  -- print('Move ' .. direction)
  _, robotX, robotY = push(roomRows, ROBOT, robotX, robotY, direction)
  -- printRoomGrid(roomRows, robotX, robotY)
end

local total = 0

for y, row in ipairs(roomRows) do
  for x, tile in ipairs(row) do
    if tile == BOX then
      total = total + getCoordinateValue(x, y)
    end
  end
end

print(total)
