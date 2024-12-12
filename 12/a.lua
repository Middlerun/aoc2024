require('utils')
require('12/common')

local function getRegionFencePrice(rows, region)
  local maxX = #rows[1]
  local maxY = #rows
  local perimeter = 0
  for _, plot in ipairs(region.plots) do
    local x = plot.x
    local y = plot.y
    if x == 1 or rows[y][x - 1] ~= region.cropId then perimeter = perimeter + 1 end
    if y == 1 or rows[y - 1][x] ~= region.cropId then perimeter = perimeter + 1 end
    if x == maxX or rows[y][x + 1] ~= region.cropId then perimeter = perimeter + 1 end
    if y == maxY or rows[y + 1][x] ~= region.cropId then perimeter = perimeter + 1 end
  end
  local area = #region.plots
  return perimeter * area
end

local rows = readGridInput()

local regions = identifyRegions(rows)

local total = 0

for _, region in ipairs(regions) do
  total = total + getRegionFencePrice(rows, region)
end

print(total)
