require('utils')
require('02/common')

local function isReportSafe(report)
  if isReportSafeWithSkip(report, nil) then return true end

  for i = 1, #report do
    if isReportSafeWithSkip(report, i) then return true end
  end

  return false
end

local safeReportCount = 0

for line in readInput() do
  if isReportSafe(parseLine(line)) then
    safeReportCount = safeReportCount + 1
  end
end

print(safeReportCount)
