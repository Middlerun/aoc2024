require('utils')

-- vertical pattern
-- starts at 20 then reoccurs every 101 seconds

-- horizontal pattern
-- starts at 90 then reoccurs every 103 seconds

-- Xmas tree occurs at the point where these two patterns intersect

for i = 20, 100000, 101 do
  if (i - 90) % 103 == 0 then
    print(i)
    break
  end
end

-- require('14/common')

-- local robots = {}

-- for line in readInput() do
--   local px, py, vx, vy = line:match('p=(%d+),(%d+) v=(%-?%d+),(%-?%d+)')

--   table.insert(robots, {
--     px = tonumber(px),
--     py = tonumber(py),
--     vx = tonumber(vx),
--     vy = tonumber(vy),
--   })
-- end

-- code used to visualise the positions and identify the patterns:
-- local function pause()
--   io.stdin:read '*l'
-- end

-- local clock = os.clock
-- local function sleep(n) -- seconds
--   local t0 = clock()
--   while clock() - t0 <= n do
--   end
-- end

-- for i = 1, 100000 do
--   local positions = {}
--   for _, robot in ipairs(robots) do
--     local pxFinal = (robot.px + (robot.vx * i)) % ROOM_WIDTH
--     local pyFinal = (robot.py + (robot.vy * i)) % ROOM_HEIGHT

--     local positionKey = pxFinal .. ',' .. pyFinal
--     positions[positionKey] = (positions[positionKey] or 0) + 1
--   end

--   print('After ' .. i .. ' seconds:')
--   displayPositions(positions)
--   if i % 100 == 0 then
--     print('Press enter to continue...')
--     pause()
--     print('')
--   else
--     sleep(0.5)
--   end
-- end
