require('utils')
require('vec2')

local UP = 1
local DOWN = 2
local LEFT = 3
local RIGHT = 4

local MOVEMENT_DIRECTIONS = {
  [UP] = Vec2:new(0, -1),
  [DOWN] = Vec2:new(0, 1),
  [RIGHT] = Vec2:new(1, 0),
  [LEFT] = Vec2:new(-1, 0),
}

local EMPTY = '.'

---@type Vec2
local startPos
---@type Vec2
local endPos

local rows = readGridInput(function(tile, x, y)
  if tile == 'S' then
    startPos = Vec2:new(x, y)
    return EMPTY
  elseif tile == 'E' then
    endPos = Vec2:new(x, y)
    return EMPTY
  end
  return tile
end)

---@param space Vec2
---@return string | nil
local function getTile(space)
  if rows[space.y] then
    return rows[space.y][space.x]
  end
end

-- Step one: get positions of the track spaces

local prevPos = Vec2:new(-1, -1)
local currentPos = startPos
local trackPositions = { startPos }

while currentPos ~= endPos do
  for _, direction in ipairs(MOVEMENT_DIRECTIONS) do
    local pos = currentPos + direction
    if pos ~= prevPos and getTile(pos) == EMPTY then
      prevPos = currentPos
      currentPos = pos
      table.insert(trackPositions, pos)
      break
    end
  end
end

-- Step two: Map positions to their distance from the start

local distanceMap = {}

for i, pos in ipairs(trackPositions) do
  distanceMap[tostring(pos)] = i - 1
end

-- Step three: For each track position, find possible cheats

local cheatsByTimeSaved = {}
local totalCheatsThatSaveAtLeast100Picoseconds = 0

local CHEAT_TIME = 20

for i, pos in ipairs(trackPositions) do
  local currentDistance = i - 1
  for dy = -CHEAT_TIME, CHEAT_TIME do
    local maxDx = CHEAT_TIME - math.abs(dy)
    for dx = -maxDx, maxDx do
      local cheatDistance = math.abs(dx) + math.abs(dy)
      local cheatPos = Vec2:new(pos.x + dx, pos.y + dy)
      local cheatPosDistance = distanceMap[tostring(cheatPos)]
      if cheatPosDistance then
        local timeSaved = cheatPosDistance - (currentDistance + cheatDistance)
        if timeSaved > 0 then
          cheatsByTimeSaved[timeSaved] = (cheatsByTimeSaved[timeSaved] or 0) + 1
          if timeSaved >= 100 then
            totalCheatsThatSaveAtLeast100Picoseconds = totalCheatsThatSaveAtLeast100Picoseconds + 1
          end
        end
      end
    end
  end
end

print(totalCheatsThatSaveAtLeast100Picoseconds)
