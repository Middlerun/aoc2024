require('utils')
require('12/common')

local function plotEdgeKey(x, y, direction)
  return x .. ',' .. y .. '-' .. direction.name
end

local fenceDirections = {
  { name = 'up',    edge = { x = 0, y = -1 }, run = { x = 1, y = 0 } },
  { name = 'down',  edge = { x = 0, y = 1 },  run = { x = 1, y = 0 } },
  { name = 'left',  edge = { x = -1, y = 0 }, run = { x = 0, y = 1 } },
  { name = 'right', edge = { x = 1, y = 0 },  run = { x = 0, y = 1 } },
}

local function getRegionFencePrice(rows, region)
  local sides = {}
  local plotEdgeCounted = {}

  -- First, sort the plots. This way, as we iterate through them we'll be going left to right, up to down,
  -- which makes the algorithm simpler.
  table.sort(region.plots, function(a, b)
    if a.y == b.y then
      return a.x < b.x
    else
      return a.y < b.y
    end
  end)

  local function cropVal(x, y)
    if not rows[y] then return '.' end
    return rows[y][x] or '.'
  end

  for _, plot in ipairs(region.plots) do
    for _, direction in ipairs(fenceDirections) do
      if (cropVal(plot.x + direction.edge.x, plot.y + direction.edge.y) ~= region.cropId) and not plotEdgeCounted[plotEdgeKey(plot.x, plot.y, direction)] then
        local newSide = { id = #sides + 1 }
        local x = plot.x
        local y = plot.y
        repeat
          plotEdgeCounted[plotEdgeKey(x, y, direction)] = true
          x = x + direction.run.x
          y = y + direction.run.y
        until cropVal(x, y) ~= region.cropId or cropVal(x + direction.edge.x, y + direction.edge.y) == region.cropId
        table.insert(sides, newSide)
      end
    end
  end

  local area = #region.plots
  return #sides * area
end

local rows = readGridInput()

local regions = identifyRegions(rows)

local total = 0

for _, region in ipairs(regions) do
  total = total + getRegionFencePrice(rows, region)
end

print(total)
