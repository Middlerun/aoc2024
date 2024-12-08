function parseInput()
  local antennasByFrequency = {}

  local maxX = 0
  local maxY = 0

  local y = 0
  for line in readInput() do
    y = y + 1
    local cells = stringSplit(line, '')

    maxX = #cells
    maxY = y

    for x, cell in ipairs(cells) do
      if cell ~= '.' then
        if not antennasByFrequency[cell] then
          antennasByFrequency[cell] = {}
        end
        table.insert(antennasByFrequency[cell], { x = x, y = y })
      end
    end
  end

  local function nodeInMap(node)
    return node.x > 0 and node.y > 0 and node.x <= maxX and node.y <= maxY
  end

  return antennasByFrequency, nodeInMap
end

function nodeToString(node)
  return node.x .. ',' .. node.y
end
