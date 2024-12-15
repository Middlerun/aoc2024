require('utils')

WALL = '#'
BOX = 'O'
BOX_LEFT = '['
BOX_RIGHT = ']'
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
      local inputRow = stringSplit(line, '')
      local row = {}
      local robotRowX = line:find('@')
      if robotRowX then
        robotX = robotRowX * 2 - 1
        robotY = #roomRows + 1
        inputRow[robotX] = EMPTY
      end
      for _, char in ipairs(inputRow) do
        if char == WALL then
          table.insert(row, WALL)
          table.insert(row, WALL)
        elseif char == BOX then
          table.insert(row, BOX_LEFT)
          table.insert(row, BOX_RIGHT)
        else
          table.insert(row, EMPTY)
          table.insert(row, EMPTY)
        end
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

---@param roomRows string[][]
---@param pusherType string
---@param pusherX integer
---@param pusherY integer
---@param direction string
---@return boolean
---@return string[][]
---@return integer
---@return integer
local function push(roomRows, pusherType, pusherX, pusherY, direction)
  local pushedX = pusherX + DIRECTIONS[direction].x
  local pushedY = pusherY + DIRECTIONS[direction].y
  local pushed = roomRows[pushedY][pushedX]

  if pushed == WALL then
    return false, roomRows, pusherX, pusherY
  elseif pushed == EMPTY then
    local newRoomRows = deepClone(roomRows)
    if pusherType ~= ROBOT then
      newRoomRows[pushedY][pushedX] = pusherType
      newRoomRows[pusherY][pusherX] = EMPTY
    end
    return true, newRoomRows, pushedX, pushedY
  elseif pushed == BOX_LEFT or BOX_RIGHT then
    local didPush, newRoomRows = push(roomRows, pushed, pushedX, pushedY, direction)

    if didPush and (direction == UP or direction == DOWN) then
      -- Need to also push the other half of the box.
      local otherHalfPushedX
      if pushed == BOX_LEFT then
        otherHalfPushedX = pushedX + 1
      else
        otherHalfPushedX = pushedX - 1
      end
      local otherHalfPushedType = roomRows[pushedY][otherHalfPushedX]
      didPush, newRoomRows = push(newRoomRows, otherHalfPushedType, otherHalfPushedX, pushedY, direction)
    end

    if didPush then
      newRoomRows = deepClone(newRoomRows)

      if pusherType ~= ROBOT then
        newRoomRows[pushedY][pushedX] = pusherType
        newRoomRows[pusherY][pusherX] = EMPTY
      end
      return true, newRoomRows, pushedX, pushedY
    else
      return false, roomRows, pusherX, pusherY
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
  _, roomRows, robotX, robotY = push(roomRows, ROBOT, robotX, robotY, direction)
  -- printRoomGrid(roomRows, robotX, robotY)
end

local total = 0

for y, row in ipairs(roomRows) do
  for x, tile in ipairs(row) do
    if tile == BOX_LEFT then
      total = total + getCoordinateValue(x, y)
    end
  end
end

print(total)
