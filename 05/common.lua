function parseInput()
  local rulesByFirstPage = {}
  local rulesBySecondPage = {}
  local updates = {}

  local isParsingRules = true

  for line in readInput() do
    if line == '' then
      isParsingRules = false
    elseif isParsingRules then
      local rule = map(stringSplit(line, '|'), tonumber)

      if not rulesByFirstPage[rule[1]] then
        rulesByFirstPage[rule[1]] = {}
      end
      table.insert(rulesByFirstPage[rule[1]], rule)

      if not rulesBySecondPage[rule[2]] then
        rulesBySecondPage[rule[2]] = {}
      end
      table.insert(rulesBySecondPage[rule[2]], rule)
    else
      local update = map(stringSplit(line, ','), tonumber)
      table.insert(updates, update)
    end
  end

  return updates, rulesByFirstPage, rulesBySecondPage
end

function isUpdateValid(update, rulesByFirstPage)
  local prevPageNumbers = {}
  local isValid = true

  for _, n in ipairs(update) do
    local rules = rulesByFirstPage[n] or {}

    for _, rule in ipairs(rules) do
      local pageThatMustBeLater = rule[2]

      if prevPageNumbers[pageThatMustBeLater] then
        isValid = false
        break
      end
    end

    if not isValid then
      break
    end

    prevPageNumbers[n] = true
  end

  return isValid
end
