local function coordsToStr(x, y)
  return x .. ',' .. y
end

function identifyRegions(rows)
  local maxX = #rows[1]
  local maxY = #rows
  local regions = {}
  local coordsToRegion = {}

  local function mapRegion(region, x, y)
    local plotKey = coordsToStr(x, y)
    if coordsToRegion[plotKey] then
      -- We've already mapped this node
      return
    end

    local cropIdHere = rows[y][x]
    if cropIdHere ~= region.cropId then
      return
    end

    table.insert(region.plots, { x = x, y = y })
    coordsToRegion[plotKey] = region

    if x > 1 then mapRegion(region, x - 1, y) end
    if y > 1 then mapRegion(region, x, y - 1) end
    if x < maxX then mapRegion(region, x + 1, y) end
    if y < maxY then mapRegion(region, x, y + 1) end
  end

  for y = 1, #rows do
    local row = rows[y]
    for x = 1, #row do
      local plotKey = coordsToStr(x, y)
      if not coordsToRegion[plotKey] then
        local region = {
          id = #regions + 1,
          cropId = row[x],
          plots = {},
        }
        table.insert(regions, region)
        mapRegion(region, x, y)
      end
    end
  end

  return regions
end
