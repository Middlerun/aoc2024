function parseLine(line)
  local report = {}
  for n in line:gmatch('%d+') do
    table.insert(report, tonumber(n))
  end
  return report
end

function isChangeSafe(direction, a, b)
  local diff = b - a
  if direction == 'up' then
    return diff >= 1 and diff <= 3
  else
    return diff <= -1 and diff >= -3
  end
end

function isReportSafeWithSkip(report, skipLevelIndex)
  local prev = nil
  local direction = nil

  for i, n in ipairs(report) do
    if i ~= skipLevelIndex then
      if type(prev) == 'number' then
        -- Determine direction
        if type(direction) == 'nil' then
          if (n > prev) then direction = 'up' else direction = 'down' end
        end

        -- Determine if change between the previous number and this one is safe
        if (not isChangeSafe(direction, prev, n)) then
          return false
        end
      end
      prev = n
    end
  end
  return true
end
